require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated administrator_spec.rb with fixtures loaded" do
  fixtures :administrators

  specify "fixtures should load two Administrators" do
    Administrator.should have(2).records
  end
end
