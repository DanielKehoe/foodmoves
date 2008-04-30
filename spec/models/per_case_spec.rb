require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated per_case_spec.rb with fixtures loaded" do
  fixtures :per_cases

  specify "fixtures should load two PerCases" do
    PerCase.should have(2).records
  end
end
