require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DataMapper::Is::Remixable do

  it "should not alter the common Module namespace" do
    Module.respond_to?(:property).should   be_false
    Module.respond_to?(:belongs_to).should be_false
    Module.respond_to?(:has).should        be_false
  end


  it "should provide the property method in the remixable module" do
    Addressable.respond_to?(:property).should be_true
  end

  it "should provide the belongs_to method in the remixable module" do
    Addressable.respond_to?(:belongs_to).should be_true
  end

  it "should provide the has method in the remixable module" do
    Addressable.respond_to?(:has).should be_true
  end


  it "should provide the property_declarations method" do
    Addressable.respond_to?(:property_declarations).should be_true
  end

  it "should provide the belongs_to_declarations method" do
    Addressable.respond_to?(:belongs_to_declarations).should be_true
  end

  it "should provide the has_declarations method" do
    Addressable.respond_to?(:has_declarations).should be_true
  end


  it "should store all property declarations" do
    Addressable.property_declarations.size.should == 2
    Addressable.property_declarations.should include([ :id,      DataMapper::Types::Serial       ])
    Addressable.property_declarations.should include([ :address, String,  { :nullable => false } ])
  end

  it "should store all belongs_to declarations" do
    Addressable.belongs_to_declarations.size.should == 1
    Addressable.belongs_to_declarations.should include([ :country ])
  end

  it "should store all has declarations" do
    Addressable.has_declarations.size.should == 1
    Addressable.has_declarations.should include([ 1.0/0, :phone_numbers ])
  end


  it "should store its descendants" do
    DataMapper::Is::Remixable.descendants.size.should == 2
  end

  it "should follow naming conventions for storing descendants" do
    DataMapper::Is::Remixable.descendants[:addressable][:module].should == Addressable
  end

end

describe DataMapper::Is::Remixable::Remixer do

  include RemixableHelper

  describe "Calling remix on a DataMapper::Resource" do

    before(:all) do
      clear_remixed_models 'PersonAddress'
      Person.auto_migrate!
      Person.remix 1, :address, 'PersonAddress', :remixable => :addressable
    end

    it "should respect naming conventions when defining the remixed model" do
      Object.const_defined?('PersonAddress').should be_true
    end

    it "should allow to auto_migrate the remixed model" do
      lambda { PersonAddress.auto_migrate! }.should_not raise_error
    end

    it "should replay all properties in the remixed model" do
      PersonAddress.properties.count.should == 4
      PersonAddress.properties.named?(:id).should         be_true
      PersonAddress.properties.named?(:address).should    be_true
      PersonAddress.properties.named?(:person_id).should  be_true
      PersonAddress.properties.named?(:country_id).should be_true
    end

    it "should replay all relationships in the remixed model" do
      PersonAddress.relationships(:default)[:country]      .kind_of?(
        DataMapper::Associations::ManyToOne::Relationship
      ).should be_true
      PersonAddress.relationships(:default)[:phone_numbers].kind_of?(
        DataMapper::Associations::OneToMany::Relationship
      ).should be_true
    end

  end

end
