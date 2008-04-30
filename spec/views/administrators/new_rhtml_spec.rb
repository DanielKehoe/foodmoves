require File.dirname(__FILE__) + '/../../spec_helper'

context "/administrators/new.rhtml" do
  include AdministratorsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @administrator = mock("administrator")
    @administrator.stub!(:to_param).and_return("99")
    @administrator.stub!(:errors).and_return(@errors)
    @administrator.stub!(:email).and_return("MyString")
    @administrator.stub!(:first_name).and_return("MyString")
    @administrator.stub!(:last_name).and_return("MyString")
    @administrator.stub!(:password).and_return("MyString")

    assigns[:administrator] = @administrator
  end

  specify "should render new form" do
    render "/administrators/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => administrators_path, :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'administrator[email]'}
    response.should_have_tag 'input', :attributes =>{:name => 'administrator[first_name]'}
    response.should_have_tag 'input', :attributes =>{:name => 'administrator[last_name]'}
    response.should_have_tag 'input', :attributes =>{:name => 'administrator[password]'}
  end
end


