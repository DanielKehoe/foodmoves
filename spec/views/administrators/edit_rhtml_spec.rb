require File.dirname(__FILE__) + '/../../spec_helper'

context "/administrators/edit.rhtml" do
  include AdministratorsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @administrator = mock_model(Administrator, :errors => @errors)
    @administrator.stub!(:email).and_return("MyString")
    @administrator.stub!(:first_name).and_return("MyString")
    @administrator.stub!(:last_name).and_return("MyString")
    @administrator.stub!(:password).and_return("MyString")

    assigns[:administrator] = @administrator
  end

  specify "should render edit form" do
    render "/administrators/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => administrator_path(@administrator), :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'administrator[email]'}
    response.should_have_tag 'input', :attributes =>{:name => 'administrator[first_name]'}
    response.should_have_tag 'input', :attributes =>{:name => 'administrator[last_name]'}
    response.should_have_tag 'input', :attributes =>{:name => 'administrator[password]'}
  end
end


