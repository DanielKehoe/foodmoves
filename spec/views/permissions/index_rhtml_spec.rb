require File.dirname(__FILE__) + '/../../spec_helper'

context "/permissions/index.rhtml" do
  include PermissionsHelper
  
  setup do
    permission_98 = mock("permission_98")
    permission_98.stub!(:to_param).and_return("98")
    permission_98.should_receive(:user_id).and_return("1")
    permission_98.should_receive(:role_id).and_return("1")
    permission_98.should_receive(:created_at).and_return(Time.now)
    permission_98.should_receive(:updated_at).and_return(Time.now)

    permission_99 = mock("permission_99")
    permission_99.stub!(:to_param).and_return("99")
    permission_99.should_receive(:user_id).and_return("1")
    permission_99.should_receive(:role_id).and_return("1")
    permission_99.should_receive(:created_at).and_return(Time.now)
    permission_99.should_receive(:updated_at).and_return(Time.now)

    assigns[:permissions] = [permission_98, permission_99]
  end

  specify "should render list of permissions" do
    render "/permissions/index.rhtml"

  end
end

