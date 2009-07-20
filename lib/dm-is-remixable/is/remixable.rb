module DataMapper
  module Is
    module Remixable

      include Extlib::Assertions

      def is_remixable
        class << self; self end.send(:include, Remixee)
        name = Extlib::Inflection.demodulize(self.name).snake_case.to_sym
        (Remixable.descendants[name] ||= {})[:module] = self
      end

      def self.descendants
        @descendants ||= {}
      end

      module Remixee

        %w(property belongs_to has).each do |name|

          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{name}(*args)             # def property(*args)
              #{name}_declarations << args #   property_declarations << args
            end                            # end

            def #{name}_declarations       # def property_declarations
              @#{name}_declarations ||= [] #   @property_declarations ||= []
            end                            # end
          RUBY

        end

      end

      module Remixer

        # TODO think about handling different repositories
        def remix(cardinality, relationship_name, *args)

          assert_kind_of 'cardinality',       cardinality,       Integer, Range, n.class
          assert_kind_of 'relationship_name', relationship_name, Symbol

          source_model_name = self.name
          target_model_name = extract_model(args)
          options           = extract_options(args)

          assert_valid_options_for_remix(options)

          if options.key?(:model) && target_model_name
            raise ArgumentError, 'should not specify options[:model] if passing the model in the third argument'
          end

          target_model_name ||= options.delete(:model)

          options = {
            :target_key   => Extlib::Inflection.foreign_key(source_model_name),
            :storage_name => Extlib::Inflection.tableize(target_model_name),
            :unique       => false
          }.merge!(options)

          if options[:through]
            remix_intermediate_model(cardinality, relationship_name, target_model_name, options)
          else
            remix_target_model(cardinality, relationship_name, target_model_name, options)
          end

        end

        def remixables
          @remixables
        end


        private

        def remix_target_model(cardinality, target_relationship_name, target_model_name, options)

          source_model = self
          target_model = remixable_model(target_model_name, options.delete(:remixable))
          target_key   = options[:target_key].first.to_sym # TODO think about supporting CPKs if possible

          if options.delete(:unique) || cardinality == 1
            target_model.property target_key, Integer, :nullable => false, :unique => true, :unique_index => true
          end

          source = target_key.to_s.gsub('_id', '').to_sym
          target_model.belongs_to source, source_model, :source_key => target_key
          source_model.has cardinality, target_relationship_name, target_model, options

        end

        # TODO finish rewrite
        def remix_intermediate_model(cardinality, target_relationship_name, target_model_name, options)

          source_model                    = self
          default_intermediate_source_key = Extlib::Inflection.foreign_key(source_model.name)
          default_intermediate_target_key = Extlib::Inflection.foreign_key(target_model_name)

          case through = options[:through]
          when Symbol
            intermediate_name       = "#{self.name.snake_case}_#{target_relationship_name}".to_sym
            intermediate_model_name = "#{self.name}#{target_relationship_name.to_s.singular_camel_case}"
            intermediate_source_key = default_intermediate_source_key
            intermediate_target_key = default_intermediate_target_key
            remixable               = through
          when Array
            intermediate_name       = through.first
            intermediate_model_name = through.last[:model]
            intermediate_source_key = through.last[:source_key] || default_intermediate_source_key
            intermediate_target_key = through.last[:target_key] || default_intermediate_target_key
            remixable               = through.last[:remixable]
          else
            raise ArgumentError, '+options[:through]+ must either be a Symbol or an Array'
          end

          intermediate_model  = remixable_model(intermediate_model_name, remixable)
          intermediate_source = intermediate_source_key.gsub('_id', '').to_sym
          intermediate_target = intermediate_target_key.gsub('_id', '').to_sym

          # add properties and associations to intermediate model

          if options[:unique]
            intermediate_model.property intermediate_source_key.to_sym, Integer, :nullable => false, :key => true
            intermediate_model.property intermediate_target_key.to_sym, Integer, :nullable => false, :key => true
          end

          intermediate_model.belongs_to intermediate_source
          intermediate_model.belongs_to intermediate_target

          # establish relationships to intermediate and target model

          self.has cardinality, intermediate_name, remixable_model, options
          self.has cardinality, relationship_name, target_model_name, :through => remixable_model

          # TODO think about establishing the inverse m:m too

        end

        def remixable_model(model_name, remixable)

          if Object.full_const_defined?(model_name)
            model = Object.full_const_get(model_name)
            raise ArgumentError, "#{model} is not remixable" unless model.is_remixable?
            model
          else
            generate_remixable_model(model_name, remixable)
          end

        end

        def generate_remixable_model(model_name, remixable)

          remixable_config = DataMapper::Is::Remixable.descendants[remixable]
          remixable_module = remixable_config[:module] if remixable_config

          raise ArgumentError, "#{remixable} is not remixable" unless remixable_module

          klass = Class.new do
            include DataMapper::Resource
            include remixable_module
          end

          model_class = Object.full_const_set(model_name, klass)

          # replay properties and relationships
          remixable_module.property_declarations.each   { |args| model_class.property   *args }
          remixable_module.belongs_to_declarations.each { |args| model_class.belongs_to *args }
          remixable_module.has_declarations.each        { |args| model_class.has        *args }

          DataMapper.logger.info "Generated Remixable Model: #{model_name}"

          model_class

        end

        def assert_valid_options_for_remix(options)

          if options.key?(:model)
            assert_kind_of 'options[:model]', options[:model], String, Module
          end

          if options.key?(:through)
            assert_kind_of 'options[:through]', options[:through], Symbol, Module, Enumerable
            if options[:through].respond_to?(:size)
              msg = 'options[:through] must either be Symbol, Module or an Enumerable with 2 elements'
              raise ArgumentError, msg unless options[:through].size == 2
            end
          end

          [ :via, :inverse ].each do |key|
            if options.key?(key)
              assert_kind_of "options[#{key.inspect}]", options[key], Symbol, Associations::Relationship
            end
          end

          [ :source_key, :target_key ].each do |key|
            if options.key?(key)
              assert_kind_of "options[#{key.inspect}]", options[key], Enumerable
            end
          end

        end

      end

    end
  end
end
