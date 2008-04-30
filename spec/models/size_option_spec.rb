require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated size_option_spec.rb with fixtures loaded" do
  fixtures :size_options

  specify "fixtures should load two SizeOptions" do
    SizeOption.should have(2).records
  end
end
