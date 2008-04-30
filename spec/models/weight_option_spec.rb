require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated weight_option_spec.rb with fixtures loaded" do
  fixtures :weight_options

  specify "fixtures should load two WeightOptions" do
    WeightOption.should have(2).records
  end
end
