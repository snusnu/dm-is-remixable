module DataMapper
  module Is
    module Remixable

      class InvalidOptions       < ArgumentError; end
      class InvalidRemixable     < ArgumentError; end
      class UnknownRemixable     < ArgumentError; end
      class DuplicateRemixTarget < ArgumentError; end

      include Extlib::Assertions

      def is_remixable
        extend Remixee
        name = Extlib::Inflection.demodulize(self.name).snake_case.to_sym
        (Remixable.descendants[name] ||= {})[:module] = self
      end

      def self.descendants
        @descendants ||= {}
      end

      module Remixee

        SHIMS = %w(property belongs_to has remix)

        SHIMS.each do |name|

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

        # TODO handle storage_name option for remixed model
        # TODO think about handling different repositories
        def remix(cardinality, relationship_name, *args)

          assert_kind_of 'cardinality',       cardinality,       Integer, Range, n.class
          assert_kind_of 'relationship_name', relationship_name, Symbol

          source_model_name = self.name
          target_model_name = extract_model(args)
          options           = extract_options(args)

          assert_valid_options_for_remix(options)

          if options.key?(:model) && target_model_name
            raise InvalidOptions, 'should not specify options[:model] if passing the model in the third argument'
          end

          target_model_name ||= options.delete(:model)

          options = {
            :target_key => [ Extlib::Inflection.foreign_key(source_model_name).to_sym ]
          }.merge!(options)

          if options[:through]
            remix_intermediate_model(cardinality, relationship_name, target_model_name, options)
          else
            remix_target_model(cardinality, relationship_name, target_model_name, options)
          end

        end


        private

        # TODO think about supporting CPKs
        def remix_target_model(cardinality, target_relationship_name, target_model_name, options)

          if cardinality == n && options[:unique]
            raise InvalidOptions, 'cardinality "n" in combination with :unique => true makes no sense'
          end

          source_model = self
          target_model = remixable_model(target_model_name, options.delete(:remixable))
          target_key   = options.delete(:target_key)

          unique = options.delete(:unique)

          # default to true if cardinality is 1 and :unique option was not explicitly specified
          unique = (cardinality == 1 && unique.nil?) ? true : unique

          if unique
            # TODO think about supporting CPKs
            target_model.property target_key.first, Integer, :nullable => false, :unique => true, :unique_index => true
          end

          # TODO think about supporting CPKs
          source = target_key.first.to_s.gsub('_id', '').to_sym
          target_model.belongs_to source, source_model, :source_key => target_key
          source_model.has cardinality, target_relationship_name, target_model, options

        end

        # TODO think about supporting CPKs
        def remix_intermediate_model(cardinality, target_relationship_name, target_model_name, options)

          source_model                    = self

          default_intermediate_source_key = Extlib::Inflection.foreign_key(source_model.name)
          default_intermediate_target_key = Extlib::Inflection.foreign_key(target_model_name)
          default_intermediate_name       = "#{self.name.snake_case}_#{target_relationship_name}".to_sym
          default_intermediate_model_name = "#{default_intermediate_name.to_s.singular.camel_case}"

          case through = options.delete(:through)
          when Symbol, String, Module
            intermediate_name       = default_intermediate_name
            intermediate_model_name = default_intermediate_model_name
            intermediate_source_key = default_intermediate_source_key
            intermediate_target_key = default_intermediate_target_key
            remixable               = through
          when Array
            intermediate_name       = through.first
            through                 = through.last
            intermediate_model_name = through[:model]                 || default_intermediate_model_name
            intermediate_source_key = through[:source_key].first.to_s || default_intermediate_source_key
            intermediate_target_key = through[:target_key].first.to_s || default_intermediate_target_key
            remixable               = through[:remixable]
          else
            msg = "+options[:through]+ must be Symbol, String, Module or Array but was #{through.class}"
            raise InvalidOptions, msg
          end

          intermediate_model  = remixable_model(intermediate_model_name, remixable)
          intermediate_source = intermediate_source_key.gsub('_id', '').to_sym
          intermediate_target = intermediate_target_key.gsub('_id', '').to_sym

          # add properties and associations to the intermediate model

          intermediate_fk_options = if intermediate_model.key.empty?
            { :nullable => false, :key => true }
          elsif options[:unique]
            { :nullable => false, :unique => true, :unique_index => true }
          else
            { :nullable => false }
          end

          intermediate_model.property intermediate_source_key.to_sym, Integer, intermediate_fk_options
          intermediate_model.property intermediate_target_key.to_sym, Integer, intermediate_fk_options

          intermediate_model.belongs_to intermediate_source, source_model
          intermediate_model.belongs_to intermediate_target, target_model_name

          # establish relationships to intermediate and target model

          # merge all other given options with the options for the target relationshi
          target_relationship_options = options.merge!(:through => intermediate_name, :via => intermediate_target)

          self.has cardinality, intermediate_name, intermediate_model
          self.has cardinality, target_relationship_name, target_model_name, target_relationship_options

          # TODO think about establishing the inverse m:m too

        end

        def remixable_model(model_name, remixable)

          if Object.full_const_defined?(model_name)
            raise DuplicateRemixTarget, "The model to remix (#{model_name}) already exists"
          end

          # TODO think about simplyfying this

          case remixable
          when Module
            remixable_module = remixable
          when String
            remixable        = Extlib::Inflection.demodulize(remixable).singular.snake_case.to_sym
            remixable_config = DataMapper::Is::Remixable.descendants[remixable]
            remixable_module = remixable_config[:module] if remixable_config
          when Symbol
            remixable_config = DataMapper::Is::Remixable.descendants[remixable]
            remixable_module = remixable_config[:module] if remixable_config
          else
            raise InvalidRemixable, 'remixable must either be a Symbol or a Module'
          end

          unless remixable_module
            raise UnknownRemixable, "The module #{remixable} is not remixable"
          end

          klass = Class.new do
            include DataMapper::Resource
            include remixable_module
          end

          model = Object.full_const_set(model_name, klass)

          Remixee::SHIMS.each do |name|
            # install collected properties, relationships and remixes in the remixed model
            remixable_module.send("#{name}_declarations").each { |args| model.send(name, *args) }
          end

          DataMapper.logger.info "Generated Remixable Model: #{model_name}"

          model

        end

        def assert_valid_options_for_remix(options)

          if options.key?(:model)
            assert_kind_of 'options[:model]', options[:model], String
          end

          [ :source_key, :target_key ].each do |key|
            if options.key?(key)
              assert_kind_of "options[#{key.inspect}]", options[key], Array
            end
          end

          if options.key?(:through)
            through = options[:through]
            assert_kind_of 'options[:through]', through, Symbol, String, Module, Array
            if through.is_a?(Array)
              msg = 'options[:through] must either be Symbol, String, Module or an Array with 2 elements'
              raise InvalidOptions, msg unless through.size == 2
              # check that the intermediate relationship name is a Symbol
              assert_kind_of 'options[:through]', through.first, Symbol
              # recursively validate options for :through
              assert_valid_options_for_remix(options[:through].last)
            end
          else
            # if no :through is given or we are recursively validating :through options
            assert_kind_of 'options[:remixable]', options[:remixable], Symbol, String, Module
          end

        end

      end

    end
  end
end
