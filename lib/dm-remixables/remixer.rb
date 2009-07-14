module DataMapper
  module Remixables

    module RemixerClassMethods

      def remix(cardinality, remixable, options={})

        #A map for remixable names to Remixed Models
        @remixables = {} if @remixables.nil?

        remixable_module = Object.full_const_get(Extlib::Inflection.classify(remixable))

        unless remixable_module.is_remixable?
          raise Exception, "#{remixable_module} is not remixable"
        end

        #Merge defaults/options
        options = {
          :as         => nil,
          :model => Extlib::Inflection.classify(self.name.snake_case + "_" + remixable_module.suffix.pluralize),
          :for        => nil,
          :on         => nil,
          :unique     => false,
          :via        => nil,
          :connect    => false
        }.merge(options)

        #Make sure the class hasn't been remixed already
        unless Object.full_const_defined?(Extlib::Inflection.classify(options[:model]))

          #Storage name of our remixed model
          options[:table_name] = Extlib::Inflection.tableize(options[:model])

          #Other model to mix with in case of M:M through Remixable
          options[:other_model] = options[:for] || options[:on]

          DataMapper.logger.info "Generating Remixed Model: #{options[:model]}"
          model = generate_remixed_model(remixable_module, options)

          # map the remixable to the remixed model
          # since this will be used from 'enhance api' i think it makes perfect sense to
          # always refer to a remixable by its demodulized snake_cased constant name
          remixable_key = Extlib::Inflection.demodulize(remixable_module.name).snake_case.to_sym
          populate_remixables_mapping(model, options.merge(:remixable_key => remixable_key))

          # attach RemixerClassMethods and RemixerInstanceMethods to remixer if defined by remixee
          if Object.full_const_defined? "#{remixable_module}::RemixerClassMethods"
            extend Object.full_const_get("#{remixable_module}::RemixerClassMethods")
          end

          if Object.full_const_defined? "#{remixable_module}::RemixerInstanceMethods"
            include Object.full_const_get("#{remixable_module}::RemixerInstanceMethods")
          end

          #Create relationships between Remixer and remixed class
          if options[:other_model]
            # M:M Class-To-Class w/ Remixable Module as intermediate table
            # has n and belongs_to (or One-To-Many)
            remix_many_to_many cardinality, model, options
          else
            # 1:M Class-To-Remixable
            # has n and belongs_to (or One-To-Many)
            remix_one_to_many cardinality, model, options
          end
        else
          DataMapper.logger.warn "#{__FILE__}:#{__LINE__} warning: already remixed constant #{options[:model]}"
        end
      end

      def enhance(remixable,remixable_model=nil, &block)
        # always use innermost singular snake_cased constant name
        remixable_name = remixable.to_s.singular.snake_case.to_sym
        class_name = if remixable_model.nil?
          @remixables[remixable_name].keys.first
        else
          Extlib::Inflection.demodulize(remixable_model.to_s).snake_case.to_sym
        end

        model = @remixables[remixable_name][class_name][:model] unless @remixables[remixable_name][class_name].nil?

        unless model.nil?
          model.class_eval &block
        else
          raise Exception, "#{remixable} must be remixed with :model option as #{remixable_model} before it can be enhanced"
        end
      end

      def remixables
        @remixables
      end


      private

      def populate_remixables_mapping(remixable_model, options)
        key = options[:remixable_key]
        accessor_name = options[:as] ? options[:as] : options[:table_name]
        @remixables[key] ||= {}
        model_key = Extlib::Inflection.demodulize(remixable_model.to_s).snake_case.to_sym
        @remixables[key][model_key] ||= {}
        @remixables[key][model_key][:reader] ||= accessor_name.to_sym
        @remixables[key][model_key][:writer] ||= "#{accessor_name}=".to_sym
        @remixables[key][model_key][:model] ||= remixable_model
      end

      def remix_one_to_many(cardinality, model, options)
        self.has cardinality, (options[:as] || options[:table_name]).to_sym, :model => model.name
        model.property Extlib::Inflection.foreign_key(self.name).intern, Integer, :nullable => false
        model.belongs_to belongs_to_name(self.name)
      end

      def remix_many_to_many(cardinality, model, options)
        options[:other_model] = Object.full_const_get(Extlib::Inflection.classify(options[:other_model]))

        #TODO if options[:unique] the two *_id's need to be a unique composite key, maybe even
        # attach a validates_is_unique if the validator is included.
        puts " ~ options[:unique] is not yet supported" if options[:unique]

        # Is M:M between two different classes or the same class
        unless self.name == options[:other_model].name
          self.has cardinality, (options[:as] || options[:table_name]).to_sym, :model => model.name
          options[:other_model].has cardinality, options[:table_name].intern

          model.belongs_to belongs_to_name(self.name)
          model.belongs_to belongs_to_name(options[:other_model].name)
          if options[:connect]
            remixed = options[:as]
            remixed ||= options[:other_model].to_s.snake_case
            self.has cardinality, (options[:for] || options[:on]).snake_case.pluralize.to_sym, :through => remixed.to_sym
          end
        else
          raise Exception, "options[:via] must be specified when Remixing a module between two of the same class" unless options[:via]

          self.has cardinality, (options[:as] || options[:table_name]).to_sym, :model => model.name
          model.belongs_to belongs_to_name(self.name)
          model.belongs_to options[:via].intern, :model => options[:other_model].name, :child_key => ["#{options[:via]}_id".intern]
        end
      end

      def generate_remixed_model(remixable,options)
        #Create Remixed Model
        klass = Class.new Object do
          include DataMapper::Resource
        end

        # Give remixed model a name and create its constant
        model = Object.full_const_set(options[:model], klass)

        # Get instance methods and the :default context validator
        model.send(:include,remixable)

        if DataMapper.const_defined?('Validate')

          # Port over any other validation contexts to this model.  Skip the
          # default context since it has already been included above.
          remixable.validators.contexts.each do |context, validators|
            next if context == :default
            model.validators.contexts[context] = validators
          end

        end

        # Port the properties over
        remixable.properties.each do |prop|
          model.property(prop.name, prop.type, prop.options)
        end

        # Attach remixed model access to RemixeeClassMethods and RemixeeInstanceMethods if defined
        if Object.full_const_defined? "#{remixable}::RemixeeClassMethods"
          model.send :extend, Object.full_const_get("#{remixable}::RemixeeClassMethods")
        end

        if Object.full_const_defined? "#{remixable}::RemixeeInstanceMethods"
          model.send :include, Object.full_const_get("#{remixable}::RemixeeInstanceMethods")
        end

        model
      end

      def belongs_to_name(class_name)
        class_name.to_const_path.gsub(/\//, '_').to_sym
      end

    end

  end
end
