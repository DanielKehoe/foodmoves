require File.dirname(__FILE__) + '/../../spec_helper'

context "/invitation_codes/index.rhtml" do
  include InvitationCodesHelper
  
  setup do
    invitation_code_98 = mock("invitation_code_98")
    invitation_code_98.stub!(:to_param).and_return("98")
    invitation_code_98.should_receive(:user_id).and_return("1")
    invitation_code_98.should_receive(:role_id).and_return("1")
    invitation_code_98.should_receive(:code).and_return("MyString")
    invitation_code_98.should_receive(:response_count).and_return("1")

    invitation_code_99 = mock("invitation_code_99")
    invitation_code_99.stub!(:to_param).and_return("99")
    invitation_code_99.should_receive(:user_id).and_return("1")
    invitation_code_99.should_receive(:role_id).and_return("1")
    invitation_code_99.should_receive(:code).and_return("MyString")
    invitation_code_99.should_receive(:response_count).and_return("1")

    assigns[:invitation_codes] = [invitation_code_98, invitation_code_99]
  end

  specify "should render list of invitation_codes" do
    render "/invitation_codes/index.rhtml"

    response.should_have_tag 'td', :content => "MyString"
    response.should_have_tag 'td', :content => "1"
  end
end

