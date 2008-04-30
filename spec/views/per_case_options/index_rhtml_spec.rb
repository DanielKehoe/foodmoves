require File.dirname(__FILE__) + '/../../spec_helper'

context "/per_case_options/index.rhtml" do
  include PerCaseOptionsHelper
  
  setup do
    per_case_option_98 = mock("per_case_option_98")
    per_case_option_98.stub!(:to_param).and_return("98")
    per_case_option_98.should_receive(:food_id).and_return("1")
    per_case_option_98.should_receive(:per_case_id).and_return("1")

    per_case_option_99 = mock("per_case_option_99")
    per_case_option_99.stub!(:to_param).and_return("99")
    per_case_option_99.should_receive(:food_id).and_return("1")
    per_case_option_99.should_receive(:per_case_id).and_return("1")

    assigns[:per_case_options] = [per_case_option_98, per_case_option_99]
  end

  specify "should render list of per_case_options" do
    render "/per_case_options/index.rhtml"

  end
end

