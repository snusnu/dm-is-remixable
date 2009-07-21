describe "every remixable", :shared => true do

  it "should respect naming conventions when defining the remixed model" do
    Object.const_defined?(@remixed_model_name).should be_true
  end

  it "should allow to auto_migrate the remixed model" do
    lambda {
      remixed_model = Object.const_get(@remixed_model_name)
      remixed_model.auto_migrate!
    }.should_not raise_error
  end

end
