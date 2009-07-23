require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "every intermediate model remix", :shared => true do

  it "should establish all the remixable's properties in the remixed intermediate model" do
    @remixed_model.properties.named?(:created_at).should be_true
    @remixed_model.properties.named?(:updated_at).should be_true
  end

  it "should establish a m:m relationship from the remixer to the target model through the remixed intermediate model" do
    relationship = @source_model.relationships(:default)[:references]
    relationship.kind_of?(DataMapper::Associations::ManyToMany::Relationship).should be_true
    relationship.through.name.should == :person_references
    relationship.target_model.should == @target_model
  end

end

describe "every intermediate model remix with default options", :shared => true do

  it "should establish m:1 relationships to both source and target in the remixed intermediate model" do
    source = @remixed_model.relationships(:default)[:person]
    target = @remixed_model.relationships(:default)[:link  ]
    source.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    target.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    source.target_model.should == @source_model
    target.target_model.should == @target_model
  end

  it "should establish a 1:m relationship from the remixer to the remixed intermediate model" do
    relationship = @source_model.relationships(:default)[:person_references]
    relationship.kind_of?(DataMapper::Associations::OneToMany::Relationship).should be_true
    relationship.target_model.should == @remixed_model
  end

end

describe "every intermediate model remix with customized options", :shared => true do

  it "should establish m:1 relationships to both source and target in the remixed intermediate model" do
    source = @remixed_model.relationships(:default)[:human    ]
    target = @remixed_model.relationships(:default)[:reference]
    source.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    target.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    source.target_model.should == @source_model
    target.target_model.should == @target_model
  end

  it "should establish a 1:m relationship from the remixer to the remixed intermediate model" do
    relationship = @source_model.relationships(:default)[:person_references]
    relationship.kind_of?(DataMapper::Associations::OneToMany::Relationship).should be_true
    relationship.target_model.should == @remixed_model
  end

end
