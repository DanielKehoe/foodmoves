require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated member_spec.rb with fixtures loaded" do
  fixtures :members

  specify "fixtures should load two Members" do
    Member.should have(2).records
  end
end
