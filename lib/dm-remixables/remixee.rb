module DataMapper
  module Remixables

    module RemixeeClassMethods
      
      def default_remixable_suffix
        Extlib::Inflection.demodulize(self.name).singular.snake_case
      end

    end

  end
end
