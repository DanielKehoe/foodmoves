require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated color_option_spec.rb with fixtures loaded" do
  fixtures :color_options

  specify "fixtures should load two ColorOptions" do
    ColorOption.should have(2).records
  end
end
