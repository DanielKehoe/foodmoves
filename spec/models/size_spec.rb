require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated size_spec.rb with fixtures loaded" do
  fixtures :sizes

  specify "fixtures should load two Sizes" do
    Size.should have(2).records
  end
end
