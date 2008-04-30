require File.dirname(__FILE__) + '/../../spec_helper'

context "/conditions/new.rhtml" do
  include ConditionsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @condition = mock("condition")
    @condition.stub!(:to_param).and_return("99")
    @condition.stub!(:errors).and_return(@errors)
    @condition.stub!(:name).and_return("MyString")

    assigns[:condition] = @condition
  end

  specify "should render new form" do
    render "/conditions/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => conditions_path, :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'condition[name]'}
  end
end


