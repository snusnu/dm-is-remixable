require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '[dm-is-remixable]' do

  include RemixableHelper

  describe "Remixing an intermediate model with default options" do

    describe "and remixable as Symbol" do

      before(:all) do
        clear_remixed_models 'PersonReference'

        (@remix_lambda = lambda {
          Person.remix n, :references, 'Link', :through => :linkable
        }).call()

        @source_model  = Person
        @target_model  = Link
        @remixed_model = PersonReference

        #Person.auto_migrate!
      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every intermediate model remix'
      it_should_behave_like 'every intermediate model remix with default options'

    end

    describe "and remixable as String" do

      before(:all) do
        clear_remixed_models 'PersonReference'

        (@remix_lambda = lambda {
          Person.remix n, :references, 'Link', :through => 'Linkable'
        }).call()

        @source_model  = Person
        @target_model  = Link
        @remixed_model = PersonReference

        Person.auto_migrate!
      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every intermediate model remix'
      it_should_behave_like 'every intermediate model remix with default options'

    end

    describe "and remixable as Module" do

      before(:all) do
        clear_remixed_models 'PersonReference'

        (@remix_lambda = lambda {
          Person.remix n, :references, 'Link', :through => Linkable
        }).call()

        @source_model  = Person
        @target_model  = Link
        @remixed_model = PersonReference

        Person.auto_migrate!
      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every intermediate model remix'
      it_should_behave_like 'every intermediate model remix with default options'

    end

  end

  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------

  describe "Remixing an intermediate model with customized options" do

    describe "and remixable as Symbol" do

      before(:all) do
        clear_remixed_models 'PersonReferenceLink'

        (@remix_lambda = lambda {

          Person.remix n, :references, 'Link',
            :through => [ :person_references, {
              :remixable  => :linkable,
              :model      => 'PersonReferenceLink',
              :source_key => [:human_id],
              :target_key => [:reference_id]
            }]

        }).call()

        @source_model  = Person
        @target_model  = Link
        @remixed_model = PersonReferenceLink

        Person.auto_migrate!
      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every intermediate model remix'
      it_should_behave_like 'every intermediate model remix with customized options'

    end

    describe "and remixable as String" do

      before(:all) do
        clear_remixed_models 'PersonReferenceLink'

        (@remix_lambda = lambda {

          Person.remix n, :references, 'Link',
            :through => [ :person_references, {
              :remixable  => 'Linkable',
              :model      => 'PersonReferenceLink',
              :source_key => [:human_id],
              :target_key => [:reference_id]
            }]

        }).call()

        @source_model  = Person
        @target_model  = Link
        @remixed_model = PersonReferenceLink

        Person.auto_migrate!
      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every intermediate model remix'
      it_should_behave_like 'every intermediate model remix with customized options'

    end

    describe "and remixable as Module" do

      before(:all) do
        clear_remixed_models 'PersonReferenceLink'

        (@remix_lambda = lambda {

          Person.remix n, :references, 'Link',
            :through => [ :person_references, {
              :remixable  => Linkable,
              :model      => 'PersonReferenceLink',
              :source_key => [:human_id],
              :target_key => [:reference_id]
            }]

        }).call()

        @source_model  = Person
        @target_model  = Link
        @remixed_model = PersonReferenceLink

        Person.auto_migrate!
      end

      it_should_behave_like 'every remixable'
      it_should_behave_like 'every intermediate model remix'
      it_should_behave_like 'every intermediate model remix with customized options'

    end

  end

end
