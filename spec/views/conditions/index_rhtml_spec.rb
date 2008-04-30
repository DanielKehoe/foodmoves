require File.dirname(__FILE__) + '/../../spec_helper'

context "/conditions/index.rhtml" do
  include ConditionsHelper
  
  setup do
    condition_98 = mock("condition_98")
    condition_98.stub!(:to_param).and_return("98")
    condition_98.should_receive(:name).and_return("MyString")

    condition_99 = mock("condition_99")
    condition_99.stub!(:to_param).and_return("99")
    condition_99.should_receive(:name).and_return("MyString")

    assigns[:conditions] = [condition_98, condition_99]
  end

  specify "should render list of conditions" do
    render "/conditions/index.rhtml"

    response.should_have_tag 'td', :content => "MyString"
  end
end

