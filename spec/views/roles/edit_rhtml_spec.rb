require File.dirname(__FILE__) + '/../../spec_helper'

context "/roles/edit.rhtml" do
  include RolesHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @role = mock_model(Role, :errors => @errors)
    @role.stub!(:title).and_return("MyString")

    assigns[:role] = @role
  end

  specify "should render edit form" do
    render "/roles/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => role_path(@role), :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'role[title]'}
  end
end


