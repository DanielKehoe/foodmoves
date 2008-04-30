require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated food_spec.rb with fixtures loaded" do
  fixtures :foods

  specify "fixtures should load two Foods" do
    Food.should have(2).records
  end
end
