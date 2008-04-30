require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated per_case_option_spec.rb with fixtures loaded" do
  fixtures :per_case_options

  specify "fixtures should load two PerCaseOptions" do
    PerCaseOption.should have(2).records
  end
end
