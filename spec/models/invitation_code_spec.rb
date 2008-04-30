require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated invitation_code_spec.rb with fixtures loaded" do
  fixtures :invitation_codes

  specify "fixtures should load two InvitationCodes" do
    InvitationCode.should have(2).records
  end
end
