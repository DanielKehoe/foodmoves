require File.dirname(__FILE__) + '/../../spec_helper'

context "/per_cases/show.rhtml" do
  include PerCasesHelper
  
  setup do
    @per_case = mock("per_case")
    @per_case.stub!(:to_param).and_return("99")
    @per_case.stub!(:errors).and_return(@errors)
    @per_case.stub!(:name).and_return("MyString")

    assigns[:per_case] = @per_case
  end

  specify "should render attributes in <p>" do
    render "/per_cases/show.rhtml"

    # response.should_have_tag('p', :content => "MyString")
  end
end

