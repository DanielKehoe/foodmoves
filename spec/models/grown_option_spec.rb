require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated grown_option_spec.rb with fixtures loaded" do
  fixtures :grown_options

  specify "fixtures should load two GrownOptions" do
    GrownOption.should have(2).records
  end
end
