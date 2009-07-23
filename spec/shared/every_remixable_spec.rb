describe "every remixable", :shared => true do

  it "should allow to auto_migrate the remixed model" do
    lambda { @remixed_model.auto_migrate! }.should_not raise_error
  end

  it "should raise when trying to remix the same model more than once" do
    lambda { 2.times { @remix_lambda.call() } }.should raise_error(DataMapper::Is::Remixable::DuplicateRemixTarget)
  end

end
