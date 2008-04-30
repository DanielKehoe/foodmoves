require File.dirname(__FILE__) + '/../../spec_helper'

context "/permissions/new.rhtml" do
  include PermissionsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @permission = mock("permission")
    @permission.stub!(:to_param).and_return("99")
    @permission.stub!(:errors).and_return(@errors)
    @permission.stub!(:user_id).and_return("1")
    @permission.stub!(:role_id).and_return("1")
    @permission.stub!(:created_at).and_return(Time.now)
    @permission.stub!(:updated_at).and_return(Time.now)

    assigns[:permission] = @permission
  end

  specify "should render new form" do
    render "/permissions/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => permissions_path, :method => 'post'}

  end
end


