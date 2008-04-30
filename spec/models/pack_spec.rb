require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated pack_spec.rb with fixtures loaded" do
  fixtures :packs

  specify "fixtures should load two Packs" do
    Pack.should have(2).records
  end
end
