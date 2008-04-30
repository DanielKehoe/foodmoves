require File.dirname(__FILE__) + '/../../spec_helper'

context "/permissions/edit.rhtml" do
  include PermissionsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @permission = mock_model(Permission, :errors => @errors)
    @permission.stub!(:user_id).and_return("1")
    @permission.stub!(:role_id).and_return("1")
    @permission.stub!(:created_at).and_return(Time.now)
    @permission.stub!(:updated_at).and_return(Time.now)

    assigns[:permission] = @permission
  end

  specify "should render edit form" do
    render "/permissions/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => permission_path(@permission), :method => 'post'}

  end
end


