require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated asset_spec.rb with fixtures loaded" do
  fixtures :assets

  specify "fixtures should load two Assets" do
    Asset.should have(2).records
  end
end
