module DataMapper
  module Remixables

    def remixable(options={})

      raise ArgumentError, "You need to pass a block to 'remixable'" unless block_given?

      assert_valid_options_for_remixable(options)

      remixable = LazyModule.new do

        extend DataMapper::Is::Remixable::RemixeeClassMethods

        class_inheritable_accessor :remixable_suffix

        yield

      end

    end

    private

    def assert_valid_options_for_remixable(options)
      # TODO implement
    end

  end
end
