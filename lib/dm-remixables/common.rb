class Object

  def full_const_defined?(name)
    (full_const_get(name) || false) rescue false
  end

end

# Extlib::Inflection.rule 'ess', 'esses'


module DataMapper
  module Remixables

    module CommonClassMethods

      def is_remixable?
        @is_remixable || false
      end

    end

  end
end
