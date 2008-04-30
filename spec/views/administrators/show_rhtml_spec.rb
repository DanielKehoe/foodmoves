require File.dirname(__FILE__) + '/../../spec_helper'

context "/administrators/show.rhtml" do
  include AdministratorsHelper
  
  setup do
    @administrator = mock("administrator")
    @administrator.stub!(:to_param).and_return("99")
    @administrator.stub!(:errors).and_return(@errors)
    @administrator.stub!(:email).and_return("MyString")
    @administrator.stub!(:first_name).and_return("MyString")
    @administrator.stub!(:last_name).and_return("MyString")
    @administrator.stub!(:password).and_return("MyString")

    assigns[:administrator] = @administrator
  end

  specify "should render attributes in <p>" do
    render "/administrators/show.rhtml"

    # response.should_have_tag('p', :content => "MyString")
    # response.should_have_tag('p', :content => "MyString")
    # response.should_have_tag('p', :content => "MyString")
    # response.should_have_tag('p', :content => "MyString")
  end
end

