require File.dirname(__FILE__) + '/../../spec_helper'

context "/invitation_codes/show.rhtml" do
  include InvitationCodesHelper
  
  setup do
    @invitation_code = mock("invitation_code")
    @invitation_code.stub!(:to_param).and_return("99")
    @invitation_code.stub!(:errors).and_return(@errors)
    @invitation_code.stub!(:user_id).and_return("1")
    @invitation_code.stub!(:role_id).and_return("1")
    @invitation_code.stub!(:code).and_return("MyString")
    @invitation_code.stub!(:response_count).and_return("1")

    assigns[:invitation_code] = @invitation_code
  end

  specify "should render attributes in <p>" do
    render "/invitation_codes/show.rhtml"

    # response.should_have_tag('p', :content => "MyString")
    # response.should_have_tag('p', :content => "1")
  end
end

