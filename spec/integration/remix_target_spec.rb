require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "every target model remix", :shared => true do

  it "should establish all the remixable's properties in the remixed target model" do
    PersonAddress.properties.named?(:id        ).should be_true
    PersonAddress.properties.named?(:address   ).should be_true
    PersonAddress.properties.named?(:country_id).should be_true
  end

  it "should establish all explicitly defined relationships in the remixed target model" do
    relationships = PersonAddress.relationships(:default)
    relationships[:country      ].kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    relationships[:phone_numbers].kind_of?(DataMapper::Associations::OneToMany::Relationship).should be_true
  end

end

describe "every 1:1 target model remix", :shared => true do

  it "should establish a 1:1 relationship from the remixer to the remixed model" do
    relationship = Person.relationships(:default)[:address]
    relationship.kind_of?(DataMapper::Associations::OneToOne::Relationship).should be_true
    relationship.target_model.should == PersonAddress
  end

end

describe "every 1:1 target model remix with default options", :shared => true do

  it "should establish all implicitly defined properties in the remixed model" do
    PersonAddress.properties.named?(:person_id).should  be_true
  end

  it "should establish a m:1 relationship from the remixed model to the remixer" do
    relationship = PersonAddress.relationships(:default)[:person]
    relationship.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    relationship.target_model.should == Person
  end

end

describe "every 1:1 target model remix with customized options", :shared => true do

  it "should establish all implicitly defined properties in the remixed model" do
    PersonAddress.properties.named?(:human_id).should be_true
  end

  it "should establish a m:1 relationship from the remixed model to the remixer" do
    relationship = PersonAddress.relationships(:default)[:human]
    relationship.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    relationship.target_model.should == Person
  end

end

describe "every 1:m target model remix", :shared => true do

  it "should establish a 1:m relationship from the remixer to the remixed model" do
    relationship = Person.relationships(:default)[:addresses]
    relationship.kind_of?(DataMapper::Associations::OneToMany::Relationship).should be_true
    relationship.target_model.should == PersonAddress
  end

end

describe "every 1:m target model remix with default options", :shared => true do

  it "should establish all implicitly defined properties in the remixed model" do
    PersonAddress.properties.named?(:person_id).should be_true
  end

  it "should establish a m:1 relationship from the remixed model to the remixer" do
    relationship = PersonAddress.relationships(:default)[:person]
    relationship.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    relationship.target_model.should == Person
  end

end

describe "every 1:m target model remix with customized options", :shared => true do

  it "should establish all implicitly defined properties in the remixed model" do
    PersonAddress.properties.named?(:human_id).should be_true
  end

  it "should establish a m:1 relationship from the remixed model to the remixer" do
    relationship = PersonAddress.relationships(:default)[:human]
    relationship.kind_of?(DataMapper::Associations::ManyToOne::Relationship).should be_true
    relationship.target_model.should == Person
  end

end


# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------


describe '[dm-is-remixable]' do

  include RemixableHelper

  describe "Remixing '1' target model with default options and remixable as Symbol" do

    before(:all) do
      clear_remixed_models 'PersonAddress'
      @source_model       = Person
      @remixed_model_name = 'PersonAddress'
      Person.remix 1, :address, 'PersonAddress', :remixable => :addressable
      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'
    it_should_behave_like 'every target model remix'
    it_should_behave_like 'every 1:1 target model remix'
    it_should_behave_like 'every 1:1 target model remix with default options'

  end

  describe "Remixing '1' target model with default options and remixable as Module" do

    before(:all) do
      clear_remixed_models 'PersonAddress'
      @source_model       = Person
      @remixed_model_name = 'PersonAddress'
      Person.remix 1, :address, 'PersonAddress', :remixable => Addressable
      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'
    it_should_behave_like 'every target model remix'
    it_should_behave_like 'every 1:1 target model remix'
    it_should_behave_like 'every 1:1 target model remix with default options'

  end

  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------

  describe "Remixing '1' target model with customized options and remixable as Symbol" do

    before(:all) do
      clear_remixed_models 'PersonAddress'
      @source_model       = Person
      @remixed_model_name = 'PersonAddress'
      Person.remix 1, :address, 'PersonAddress', :remixable => :addressable, :target_key => [:human_id]
      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'
    it_should_behave_like 'every target model remix'
    it_should_behave_like 'every 1:1 target model remix'
    it_should_behave_like 'every 1:1 target model remix with customized options'

  end

  describe "Remixing '1' target model with customized options and remixable as Module" do

    before(:all) do
      clear_remixed_models 'PersonAddress'
      @source_model       = Person
      @remixed_model_name = 'PersonAddress'
      Person.remix 1, :address, 'PersonAddress', :remixable => Addressable, :target_key => [:human_id]
      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'
    it_should_behave_like 'every target model remix'
    it_should_behave_like 'every 1:1 target model remix'
    it_should_behave_like 'every 1:1 target model remix with customized options'

  end

  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------

  describe "Remixing 'n' target models with default options and remixable as Symbol" do

    before(:all) do
      clear_remixed_models 'PersonAddress'
      @source_model       = Person
      @remixed_model_name = 'PersonAddress'
      Person.remix n, :addresses, 'PersonAddress', :remixable => :addressable
      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'
    it_should_behave_like 'every target model remix'
    it_should_behave_like 'every 1:m target model remix'
    it_should_behave_like 'every 1:m target model remix with default options'

  end

  describe "Remixing 'n' target models with default options and remixable as Module" do

    before(:all) do
      clear_remixed_models 'PersonAddress'
      @source_model       = Person
      @remixed_model_name = 'PersonAddress'
      Person.remix n, :addresses, 'PersonAddress', :remixable => Addressable
      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'
    it_should_behave_like 'every target model remix'
    it_should_behave_like 'every 1:m target model remix'
    it_should_behave_like 'every 1:m target model remix with default options'

  end

  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------

  describe "Remixing 'n' target models with customized options and remixable as Symbol" do

    before(:all) do
      clear_remixed_models 'PersonAddress'
      @source_model       = Person
      @remixed_model_name = 'PersonAddress'
      Person.remix n, :addresses, 'PersonAddress', :remixable => :addressable, :target_key => [:human_id]
      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'
    it_should_behave_like 'every target model remix'
    it_should_behave_like 'every 1:m target model remix'
    it_should_behave_like 'every 1:m target model remix with customized options'

  end

  describe "Remixing 'n' target models with customized options and remixable as Module" do

    before(:all) do
      clear_remixed_models 'PersonAddress'
      @source_model       = Person
      @remixed_model_name = 'PersonAddress'
      Person.remix n, :addresses, 'PersonAddress', :remixable => Addressable, :target_key => [:human_id]
      Person.auto_migrate!
    end

    it_should_behave_like 'every remixable'
    it_should_behave_like 'every target model remix'
    it_should_behave_like 'every 1:m target model remix'
    it_should_behave_like 'every 1:m target model remix with customized options'

  end

end
