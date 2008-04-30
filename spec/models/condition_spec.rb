require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated condition_spec.rb with fixtures loaded" do
  fixtures :conditions

  specify "fixtures should load two Conditions" do
    Condition.should have(2).records
  end
end
