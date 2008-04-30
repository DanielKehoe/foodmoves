require File.dirname(__FILE__) + '/../../spec_helper'

context "/per_cases/index.rhtml" do
  include PerCasesHelper
  
  setup do
    per_case_98 = mock("per_case_98")
    per_case_98.stub!(:to_param).and_return("98")
    per_case_98.should_receive(:name).and_return("MyString")

    per_case_99 = mock("per_case_99")
    per_case_99.stub!(:to_param).and_return("99")
    per_case_99.should_receive(:name).and_return("MyString")

    assigns[:per_cases] = [per_case_98, per_case_99]
  end

  specify "should render list of per_cases" do
    render "/per_cases/index.rhtml"

    response.should_have_tag 'td', :content => "MyString"
  end
end

