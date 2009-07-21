require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "every remixed intermediate model", :shared => true do



end

describe "every m:m remix", :shared => true do



end

describe DataMapper::Is::Remixable::Remixer do

  include RemixableHelper

  describe "Person.remix n, :references, 'Link', :remixable => :linkable" do

    before(:all) do
      clear_remixed_models 'PersonReference'
      @source_model       = Person
      @remixed_model_name = 'PersonReference'
      @target_model       = Link
      Person.remix n, :references, 'Link', :through => :linkable
      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'

    it "should establish m:1 relationships to both source and target in the remixed intermediate model" do
      relationships = PersonReference.relationships(:default)
      relationships[:person].kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
      relationships[:link  ].kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    end

    it "should establish a 1:m relationship from the remixer to the remixed intermediate model" do
      relationship = Person.relationships(:default)[:person_references]
      relationship.kind_of?(DataMapper::Associations::OneToMany::Relationship).should be_true
      relationship.target_model.should == PersonReference
    end

    it "should establish a m:m relationship from the remixer to the target model through the remixed intermediate model" do
      relationship = Person.relationships(:default)[:references]
      relationship.kind_of?(DataMapper::Associations::ManyToMany::Relationship).should be_true
      relationship.through.name.should == :person_references
      relationship.target_model.should == Link
    end

  end


  describe "Person.remix n, :references, 'Link', :remixable => :linkable" do

    before(:all) do
      clear_remixed_models 'PersonReferenceLink'
      @source_model       = Person
      @remixed_model_name = 'PersonReferenceLink'
      @target_model       = Link

      Person.remix n, :references, 'Link',
        :through => [ :person_references, {
          :remixable  => :linkable,
          :model      => 'PersonReferenceLink',
          :source_key => [:human_id],          
          :target_key => [:reference_id]       
        }]

      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'

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

    it "should establish a m:m relationship from the remixer to the target model through the remixed intermediate model" do
      relationship = Person.relationships(:default)[:references]
      relationship.kind_of?(DataMapper::Associations::ManyToMany::Relationship).should be_true
      relationship.through.name.should == :person_references
      relationship.target_model.should == Link
    end

  end
end