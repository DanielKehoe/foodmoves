require File.dirname(__FILE__) + '/../../spec_helper'

context "/invitation_codes/edit.rhtml" do
  include InvitationCodesHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @invitation_code = mock_model(InvitationCode, :errors => @errors)
    @invitation_code.stub!(:user_id).and_return("1")
    @invitation_code.stub!(:role_id).and_return("1")
    @invitation_code.stub!(:code).and_return("MyString")
    @invitation_code.stub!(:response_count).and_return("1")

    assigns[:invitation_code] = @invitation_code
  end

  specify "should render edit form" do
    render "/invitation_codes/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => invitation_code_path(@invitation_code), :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'invitation_code[code]'}
    response.should_have_tag 'input', :attributes =>{:name => 'invitation_code[response_count]'}
  end
end


