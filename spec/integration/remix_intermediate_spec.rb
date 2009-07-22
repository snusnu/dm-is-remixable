require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "every intermediate model remix", :shared => true do

  it "should establish all the remixable's properties in the remixed intermediate model" do
    PersonReference.properties.named?(:id        ).should be_true
    PersonReference.properties.named?(:created_at).should be_true
    PersonReference.properties.named?(:updated_at).should be_true
  end

  it "should establish a m:m relationship from the remixer to the target model through the remixed intermediate model" do
    relationship = Person.relationships(:default)[:references]
    relationship.kind_of?(DataMapper::Associations::ManyToMany::Relationship).should be_true
    relationship.through.name.should == :person_references
    relationship.target_model.should == Link
  end

end

describe "every intermediate model remix with default options", :shared => true do

  it "should establish m:1 relationships to both source and target in the remixed intermediate model" do
    source = PersonReference.relationships(:default)[:person]
    target = PersonReference.relationships(:default)[:link  ]
    source.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    target.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    source.target_model.should == Person
    target.target_model.should == Link
  end

  it "should establish a 1:m relationship from the remixer to the remixed intermediate model" do
    relationship = Person.relationships(:default)[:person_references]
    relationship.kind_of?(DataMapper::Associations::OneToMany::Relationship).should be_true
    relationship.target_model.should == PersonReference
  end

end

describe "every intermediate model remix with customized options", :shared => true do

  it "should establish m:1 relationships to both source and target in the remixed intermediate model" do
    source = PersonReferenceLink.relationships(:default)[:human    ]
    target = PersonReferenceLink.relationships(:default)[:reference]
    source.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    target.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    source.target_model.should == Person
    target.target_model.should == Link
  end

  it "should establish a 1:m relationship from the remixer to the remixed intermediate model" do
    relationship = Person.relationships(:default)[:person_references]
    relationship.kind_of?(DataMapper::Associations::OneToMany::Relationship).should be_true
    relationship.target_model.should == PersonReferenceLink
  end

end


# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------


describe '[dm-is-remixable]' do

  include RemixableHelper

  describe "Remixing an intermediate model with default options and remixable as Symbol" do

    before(:all) do
      clear_remixed_models 'PersonReference'
      @source_model       = Person
      @remixed_model_name = 'PersonReference'
      @target_model       = Link
      (@remix_lambda       = lambda {
        Person.remix n, :references, 'Link', :through => :linkable
      }).call()
      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'
    it_should_behave_like 'every intermediate model remix'
    it_should_behave_like 'every intermediate model remix with default options'

  end

  describe "Remixing an intermediate model with default options and remixable as String" do

    before(:all) do
      clear_remixed_models 'PersonReference'
      @source_model       = Person
      @remixed_model_name = 'PersonReference'
      @target_model       = Link
      (@remix_lambda       = lambda {
        Person.remix n, :references, 'Link', :through => 'Linkable'
      }).call()
      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'
    it_should_behave_like 'every intermediate model remix'
    it_should_behave_like 'every intermediate model remix with default options'

  end

  describe "Remixing an intermediate model with default options and remixable as Module" do

    before(:all) do
      clear_remixed_models 'PersonReference'
      @source_model       = Person
      @remixed_model_name = 'PersonReference'
      @target_model       = Link
      (@remix_lambda       = lambda {
        Person.remix n, :references, 'Link', :through => Linkable
      }).call()
      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'
    it_should_behave_like 'every intermediate model remix'
    it_should_behave_like 'every intermediate model remix with default options'

  end

  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------

  describe "Remixing an intermediate model with customized options and remixable as Symbol" do

    before(:all) do
      clear_remixed_models 'PersonReferenceLink'
      @source_model       = Person
      @remixed_model_name = 'PersonReferenceLink'
      @target_model       = Link

      (@remix_lambda       = lambda {

        Person.remix n, :references, 'Link',
          :through => [ :person_references, {
            :remixable  => :linkable,
            :model      => 'PersonReferenceLink',
            :source_key => [:human_id],
            :target_key => [:reference_id]
          }]

      }).call()

      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'
    it_should_behave_like 'every intermediate model remix'
    it_should_behave_like 'every intermediate model remix with customized options'

  end

  describe "Remixing an intermediate model with customized options and remixable as String" do

    before(:all) do
      clear_remixed_models 'PersonReferenceLink'
      @source_model       = Person
      @remixed_model_name = 'PersonReferenceLink'
      @target_model       = Link

      (@remix_lambda       = lambda {

        Person.remix n, :references, 'Link',
          :through => [ :person_references, {
            :remixable  => 'Linkable',
            :model      => 'PersonReferenceLink',
            :source_key => [:human_id],
            :target_key => [:reference_id]
          }]

      }).call()

      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'
    it_should_behave_like 'every intermediate model remix'
    it_should_behave_like 'every intermediate model remix with customized options'

  end

  describe "Remixing an intermediate model with customized options and remixable as Module" do

    before(:all) do
      clear_remixed_models 'PersonReferenceLink'
      @source_model       = Person
      @remixed_model_name = 'PersonReferenceLink'
      @target_model       = Link

      (@remix_lambda       = lambda {

        Person.remix n, :references, 'Link',
          :through => [ :person_references, {
            :remixable  => Linkable,
            :model      => 'PersonReferenceLink',
            :source_key => [:human_id],
            :target_key => [:reference_id]
          }]

      }).call()

      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'
    it_should_behave_like 'every intermediate model remix'
    it_should_behave_like 'every intermediate model remix with customized options'

  end

end
