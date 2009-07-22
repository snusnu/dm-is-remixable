describe "every remixable", :shared => true do

  it "should respect naming conventions when defining the remixed model" do
    Object.full_const_defined?(@remixed_model_name).should be_true
  end

  it "should allow to auto_migrate the remixed model" do
    lambda { Object.full_const_get(@remixed_model_name).auto_migrate! }.should_not raise_error
  end

  it "should raise when trying to remix the same model more than once" do
    lambda { 2.times { @remix_lambda.call() } }.should raise_error(DataMapper::Is::Remixable::DuplicateRemixTarget)
  end

end
