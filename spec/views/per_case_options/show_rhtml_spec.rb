require File.dirname(__FILE__) + '/../../spec_helper'

context "/per_case_options/show.rhtml" do
  include PerCaseOptionsHelper
  
  setup do
    @per_case_option = mock("per_case_option")
    @per_case_option.stub!(:to_param).and_return("99")
    @per_case_option.stub!(:errors).and_return(@errors)
    @per_case_option.stub!(:food_id).and_return("1")
    @per_case_option.stub!(:per_case_id).and_return("1")

    assigns[:per_case_option] = @per_case_option
  end

  specify "should render attributes in <p>" do
    render "/per_case_options/show.rhtml"

  end
end

