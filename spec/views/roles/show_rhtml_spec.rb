require File.dirname(__FILE__) + '/../../spec_helper'

context "/roles/show.rhtml" do
  include RolesHelper
  
  setup do
    @role = mock("role")
    @role.stub!(:to_param).and_return("99")
    @role.stub!(:errors).and_return(@errors)
    @role.stub!(:title).and_return("MyString")

    assigns[:role] = @role
  end

  specify "should render attributes in <p>" do
    render "/roles/show.rhtml"

    # response.should_have_tag('p', :content => "MyString")
  end
end

