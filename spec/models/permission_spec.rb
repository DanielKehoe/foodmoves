require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated permission_spec.rb with fixtures loaded" do
  fixtures :permissions

  specify "fixtures should load two Permissions" do
    Permission.should have(2).records
  end
end
