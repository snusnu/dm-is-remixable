require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "every target model remix", :shared => true do

  it "should establish all the remixable's properties in the remixed target model" do
    @remixed_model.properties.named?(:id        ).should be_true
    @remixed_model.properties.named?(:address   ).should be_true
    @remixed_model.properties.named?(:country_id).should be_true
  end

  it "should establish all explicitly defined relationships in the remixed target model" do
    relationships = @remixed_model.relationships(:default)
    relationships[:country      ].kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    relationships[:phone_numbers].kind_of?(DataMapper::Associations::OneToMany::Relationship).should be_true
  end

end

describe "every 1:1 target model remix", :shared => true do

  it "should establish a 1:1 relationship from the remixer to the remixed model" do
    relationship = @source_model.relationships(:default)[:address]
    relationship.kind_of?(DataMapper::Associations::OneToOne::Relationship).should be_true
    relationship.target_model.should == @remixed_model
  end

end

describe "every 1:1 target model remix with default options", :shared => true do

  it "should establish all implicitly defined properties in the remixed model" do
    @remixed_model.properties.named?(:person_id).should  be_true
  end

  it "should establish a m:1 relationship from the remixed model to the remixer" do
    relationship = @remixed_model.relationships(:default)[:person]
    relationship.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    relationship.target_model.should == @source_model
  end

end

describe "every 1:1 target model remix with customized options", :shared => true do

  it "should establish all implicitly defined properties in the remixed model" do
    @remixed_model.properties.named?(:human_id).should be_true
  end

  it "should establish a m:1 relationship from the remixed model to the remixer" do
    relationship = @remixed_model.relationships(:default)[:human]
    relationship.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    relationship.target_model.should == @source_model
  end

end

describe "every 1:m target model remix", :shared => true do

  it "should establish a 1:m relationship from the remixer to the remixed model" do
    relationship = @source_model.relationships(:default)[:addresses]
    relationship.kind_of?(DataMapper::Associations::OneToMany::Relationship).should be_true
    relationship.target_model.should == @remixed_model
  end

end

describe "every 1:m target model remix with default options", :shared => true do

  it "should establish all implicitly defined properties in the remixed model" do
    @remixed_model.properties.named?(:person_id).should be_true
  end

  it "should establish a m:1 relationship from the remixed model to the remixer" do
    relationship = @remixed_model.relationships(:default)[:person]
    relationship.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    relationship.target_model.should == @source_model
  end

end

describe "every 1:m target model remix with customized options", :shared => true do

  it "should establish all implicitly defined properties in the remixed model" do
    @remixed_model.properties.named?(:human_id).should be_true
  end

  it "should establish a m:1 relationship from the remixed model to the remixer" do
    relationship = @remixed_model.relationships(:default)[:human]
    relationship.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    relationship.target_model.should == @source_model
  end

end
