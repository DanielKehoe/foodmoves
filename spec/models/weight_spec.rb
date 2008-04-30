require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated weight_spec.rb with fixtures loaded" do
  fixtures :weights

  specify "fixtures should load two Weights" do
    Weight.should have(2).records
  end
end
