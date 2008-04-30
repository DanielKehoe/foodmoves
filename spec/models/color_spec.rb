require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated color_spec.rb with fixtures loaded" do
  fixtures :colors

  specify "fixtures should load two Colors" do
    Color.should have(2).records
  end
end
