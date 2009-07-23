require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '[dm-is-remixable]' do

  include RemixableHelper

  describe "Remixing '1' target model with default options" do

    describe "and remixable as Symbol" do

      before(:all) do
        clear_remixed_models 'PersonAddress'

        (@remix_lambda = lambda {
          Person.remix 1, :address, 'PersonAddress', :remixable => :addressable
        }).call()

        @source_model  = Person
        @remixed_model = PersonAddress

        Person.auto_migrate!
      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every target model remix'
      it_should_behave_like 'every 1:1 target model remix'
      it_should_behave_like 'every 1:1 target model remix with default options'

    end

    describe "and remixable as String" do

      before(:all) do
        clear_remixed_models 'PersonAddress'

        (@remix_lambda = lambda {
          Person.remix 1, :address, 'PersonAddress', :remixable => 'Addressable'
        }).call()

        @source_model  = Person
        @remixed_model = PersonAddress

        Person.auto_migrate!
      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every target model remix'
      it_should_behave_like 'every 1:1 target model remix'
      it_should_behave_like 'every 1:1 target model remix with default options'

    end

    describe "and remixable as Module" do

      before(:all) do
        clear_remixed_models 'PersonAddress'

        (@remix_lambda = lambda {
          Person.remix 1, :address, 'PersonAddress', :remixable => Addressable
        }).call()

        @source_model  = Person
        @remixed_model = PersonAddress

        Person.auto_migrate!
      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every target model remix'
      it_should_behave_like 'every 1:1 target model remix'
      it_should_behave_like 'every 1:1 target model remix with default options'

    end

  end

  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------

  describe "Remixing '1' target model with customized options" do

    describe "and remixable as Symbol" do

      before(:all) do
        clear_remixed_models 'PersonAddress'

        (@remix_lambda = lambda {
          Person.remix 1, :address, 'PersonAddress', :remixable => :addressable, :target_key => [:human_id]
        }).call()

        @source_model  = Person
        @remixed_model = PersonAddress

        Person.auto_migrate!
      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every target model remix'
      it_should_behave_like 'every 1:1 target model remix'
      it_should_behave_like 'every 1:1 target model remix with customized options'

    end

    describe "and remixable as String" do

      before(:all) do
        clear_remixed_models 'PersonAddress'

        (@remix_lambda = lambda {
          Person.remix 1, :address, 'PersonAddress', :remixable => 'Addressable', :target_key => [:human_id]
        }).call()

        @source_model  = Person
        @remixed_model = PersonAddress

        Person.auto_migrate!
      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every target model remix'
      it_should_behave_like 'every 1:1 target model remix'
      it_should_behave_like 'every 1:1 target model remix with customized options'

    end

    describe "and remixable as Module" do

      before(:all) do

        clear_remixed_models 'PersonAddress'

        (@remix_lambda = lambda {
          Person.remix 1, :address, 'PersonAddress', :remixable => Addressable, :target_key => [:human_id]
        }).call()

        Person.auto_migrate!

        @source_model  = Person
        @remixed_model = PersonAddress

      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every target model remix'
      it_should_behave_like 'every 1:1 target model remix'
      it_should_behave_like 'every 1:1 target model remix with customized options'

    end

  end

  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------

  describe "Remixing 'n' target models with default options" do

    describe "and remixable as Symbol" do

      before(:all) do

        clear_remixed_models 'PersonAddress'

        (@remix_lambda = lambda {
          Person.remix n, :addresses, 'PersonAddress', :remixable => :addressable
        }).call()

        Person.auto_migrate!

        @source_model  = Person
        @remixed_model = PersonAddress

      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every target model remix'
      it_should_behave_like 'every 1:m target model remix'
      it_should_behave_like 'every 1:m target model remix with default options'

    end

    describe "and remixable as String" do

      before(:all) do

        clear_remixed_models 'PersonAddress'

        (@remix_lambda = lambda {
          Person.remix n, :addresses, 'PersonAddress', :remixable => 'Addressable'
        }).call()

        Person.auto_migrate!

        @source_model  = Person
        @remixed_model = PersonAddress

      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every target model remix'
      it_should_behave_like 'every 1:m target model remix'
      it_should_behave_like 'every 1:m target model remix with default options'

    end

    describe "and remixable as Module" do

      before(:all) do

        clear_remixed_models 'PersonAddress'

        (@remix_lambda = lambda {
          Person.remix n, :addresses, 'PersonAddress', :remixable => Addressable
        }).call()

        Person.auto_migrate!

        @source_model  = Person
        @remixed_model = PersonAddress

      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every target model remix'
      it_should_behave_like 'every 1:m target model remix'
      it_should_behave_like 'every 1:m target model remix with default options'

    end

  end

  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------

  describe "Remixing 'n' target models with customized options" do

    describe "and remixable as Symbol" do

      before(:all) do

        clear_remixed_models 'PersonAddress'

        (@remix_lambda = lambda {
          Person.remix n, :addresses, 'PersonAddress', :remixable => :addressable, :target_key => [:human_id]
        }).call()

        Person.auto_migrate!

        @source_model  = Person
        @remixed_model = PersonAddress

      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every target model remix'
      it_should_behave_like 'every 1:m target model remix'
      it_should_behave_like 'every 1:m target model remix with customized options'

    end

    describe "and remixable as String" do

      before(:all) do

        clear_remixed_models 'PersonAddress'

        (@remix_lambda = lambda {
          Person.remix n, :addresses, 'PersonAddress', :remixable => 'Addressable', :target_key => [:human_id]
        }).call()

        Person.auto_migrate!

        @source_model  = Person
        @remixed_model = PersonAddress

      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every target model remix'
      it_should_behave_like 'every 1:m target model remix'
      it_should_behave_like 'every 1:m target model remix with customized options'

    end

    describe "and remixable as Module" do

      before(:all) do

        clear_remixed_models 'PersonAddress'

        (@remix_lambda = lambda {
          Person.remix n, :addresses, 'PersonAddress', :remixable => Addressable, :target_key => [:human_id]
        }).call()

        Person.auto_migrate!

        @source_model  = Person
        @remixed_model = PersonAddress

      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every target model remix'
      it_should_behave_like 'every 1:m target model remix'
      it_should_behave_like 'every 1:m target model remix with customized options'

    end

  end

end
