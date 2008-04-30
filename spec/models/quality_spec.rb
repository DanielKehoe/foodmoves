require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated quality_spec.rb with fixtures loaded" do
  fixtures :qualities

  specify "fixtures should load two Qualities" do
    Quality.should have(2).records
  end
end
