require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated pack_option_spec.rb with fixtures loaded" do
  fixtures :pack_options

  specify "fixtures should load two PackOptions" do
    PackOption.should have(2).records
  end
end
