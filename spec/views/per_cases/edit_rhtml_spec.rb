require File.dirname(__FILE__) + '/../../spec_helper'

context "/per_cases/edit.rhtml" do
  include PerCasesHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @per_case = mock_model(PerCase, :errors => @errors)
    @per_case.stub!(:name).and_return("MyString")

    assigns[:per_case] = @per_case
  end

  specify "should render edit form" do
    render "/per_cases/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => per_case_path(@per_case), :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'per_case[name]'}
  end
end


