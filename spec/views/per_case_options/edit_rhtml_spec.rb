require File.dirname(__FILE__) + '/../../spec_helper'

context "/per_case_options/edit.rhtml" do
  include PerCaseOptionsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @per_case_option = mock_model(PerCaseOption, :errors => @errors)
    @per_case_option.stub!(:food_id).and_return("1")
    @per_case_option.stub!(:per_case_id).and_return("1")

    assigns[:per_case_option] = @per_case_option
  end

  specify "should render edit form" do
    render "/per_case_options/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => per_case_option_path(@per_case_option), :method => 'post'}

  end
end


