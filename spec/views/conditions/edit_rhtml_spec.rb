require File.dirname(__FILE__) + '/../../spec_helper'

context "/conditions/edit.rhtml" do
  include ConditionsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @condition = mock_model(Condition, :errors => @errors)
    @condition.stub!(:name).and_return("MyString")

    assigns[:condition] = @condition
  end

  specify "should render edit form" do
    render "/conditions/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => condition_path(@condition), :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'condition[name]'}
  end
end


