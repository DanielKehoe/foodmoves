require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated role_spec.rb with fixtures loaded" do
  fixtures :roles

  specify "fixtures should load two Roles" do
    Role.should have(2).records
  end
end
