require File.dirname(__FILE__) + '/../../spec_helper'

context "/administrators/index.rhtml" do
  include AdministratorsHelper
  
  setup do
    administrator_98 = mock("administrator_98")
    administrator_98.stub!(:to_param).and_return("98")
    administrator_98.should_receive(:email).and_return("MyString")
    administrator_98.should_receive(:first_name).and_return("MyString")
    administrator_98.should_receive(:last_name).and_return("MyString")
    administrator_98.should_receive(:password).and_return("MyString")

    administrator_99 = mock("administrator_99")
    administrator_99.stub!(:to_param).and_return("99")
    administrator_99.should_receive(:email).and_return("MyString")
    administrator_99.should_receive(:first_name).and_return("MyString")
    administrator_99.should_receive(:last_name).and_return("MyString")
    administrator_99.should_receive(:password).and_return("MyString")

    assigns[:administrators] = [administrator_98, administrator_99]
  end

  specify "should render list of administrators" do
    render "/administrators/index.rhtml"

    response.should_have_tag 'td', :content => "MyString"
    response.should_have_tag 'td', :content => "MyString"
    response.should_have_tag 'td', :content => "MyString"
    response.should_have_tag 'td', :content => "MyString"
  end
end

