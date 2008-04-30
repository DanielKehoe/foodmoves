require File.dirname(__FILE__) + '/../../spec_helper'

context "/permissions/show.rhtml" do
  include PermissionsHelper
  
  setup do
    @permission = mock("permission")
    @permission.stub!(:to_param).and_return("99")
    @permission.stub!(:errors).and_return(@errors)
    @permission.stub!(:user_id).and_return("1")
    @permission.stub!(:role_id).and_return("1")
    @permission.stub!(:created_at).and_return(Time.now)
    @permission.stub!(:updated_at).and_return(Time.now)

    assigns[:permission] = @permission
  end

  specify "should render attributes in <p>" do
    render "/permissions/show.rhtml"

  end
end

