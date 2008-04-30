require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated certification_spec.rb with fixtures loaded" do
  fixtures :certifications

  specify "fixtures should load two Certifications" do
    Certification.should have(2).records
  end
end
