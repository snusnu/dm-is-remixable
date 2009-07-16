class Object

  def full_const_defined?(name)
    !!full_const_get(name) rescue false
  end

end

# TODO find out if this is still needed
# Extlib::Inflection.rule 'ess', 'esses'


module DataMapper
  module Remixable

    module Support

      def is_remixable?
        @is_remixable || false
      end

    end

  end
end
