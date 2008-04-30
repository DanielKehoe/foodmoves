require File.dirname(__FILE__) + '/../../spec_helper'

context "/roles/new.rhtml" do
  include RolesHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @role = mock("role")
    @role.stub!(:to_param).and_return("99")
    @role.stub!(:errors).and_return(@errors)
    @role.stub!(:title).and_return("MyString")

    assigns[:role] = @role
  end

  specify "should render new form" do
    render "/roles/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => roles_path, :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'role[title]'}
  end
end


