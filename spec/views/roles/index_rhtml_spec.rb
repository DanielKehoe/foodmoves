require File.dirname(__FILE__) + '/../../spec_helper'

context "/roles/index.rhtml" do
  include RolesHelper
  
  setup do
    role_98 = mock("role_98")
    role_98.stub!(:to_param).and_return("98")
    role_98.should_receive(:title).and_return("MyString")

    role_99 = mock("role_99")
    role_99.stub!(:to_param).and_return("99")
    role_99.should_receive(:title).and_return("MyString")

    assigns[:roles] = [role_98, role_99]
  end

  specify "should render list of roles" do
    render "/roles/index.rhtml"

    response.should_have_tag 'td', :content => "MyString"
  end
end

