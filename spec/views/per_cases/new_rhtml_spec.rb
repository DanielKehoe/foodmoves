require File.dirname(__FILE__) + '/../../spec_helper'

context "/per_cases/new.rhtml" do
  include PerCasesHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @per_case = mock("per_case")
    @per_case.stub!(:to_param).and_return("99")
    @per_case.stub!(:errors).and_return(@errors)
    @per_case.stub!(:name).and_return("MyString")

    assigns[:per_case] = @per_case
  end

  specify "should render new form" do
    render "/per_cases/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => per_cases_path, :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'per_case[name]'}
  end
end


