describe "every remixable", :shared => true do

  it "should respect naming conventions when defining the remixed model" do
    Object.full_const_defined?(@remixed_model_name).should be_true
  end

  it "should allow to auto_migrate the remixed model" do
    lambda { Object.full_const_get(@remixed_model_name).auto_migrate! }.should_not raise_error
  end

  it "should not raise when performing the exact same remix more than once" do
    lambda { 2.times { @remix_lambda.call() } }.should_not raise_error
  end

end
