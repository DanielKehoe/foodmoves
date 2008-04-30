require File.dirname(__FILE__) + '/../../spec_helper'

context "/conditions/show.rhtml" do
  include ConditionsHelper
  
  setup do
    @condition = mock("condition")
    @condition.stub!(:to_param).and_return("99")
    @condition.stub!(:errors).and_return(@errors)
    @condition.stub!(:name).and_return("MyString")

    assigns[:condition] = @condition
  end

  specify "should render attributes in <p>" do
    render "/conditions/show.rhtml"

    # response.should_have_tag('p', :content => "MyString")
  end
end

