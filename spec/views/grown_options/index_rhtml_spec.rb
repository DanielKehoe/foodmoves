require File.dirname(__FILE__) + '/../../spec_helper'

context "/grown_options/index.rhtml" do
  include GrownOptionsHelper
  
  setup do
    grown_option_98 = mock("grown_option_98")
    grown_option_98.stub!(:to_param).and_return("98")
    grown_option_98.should_receive(:food_id).and_return("1")
    grown_option_98.should_receive(:grown_id).and_return("1")

    grown_option_99 = mock("grown_option_99")
    grown_option_99.stub!(:to_param).and_return("99")
    grown_option_99.should_receive(:food_id).and_return("1")
    grown_option_99.should_receive(:grown_id).and_return("1")

    assigns[:grown_options] = [grown_option_98, grown_option_99]
  end

  specify "should render list of grown_options" do
    render "/grown_options/index.rhtml"

  end
end

