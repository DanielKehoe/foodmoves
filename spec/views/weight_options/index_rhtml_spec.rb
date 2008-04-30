require File.dirname(__FILE__) + '/../../spec_helper'

context "/weight_options/index.rhtml" do
  include WeightOptionsHelper
  
  setup do
    weight_option_98 = mock("weight_option_98")
    weight_option_98.stub!(:to_param).and_return("98")
    weight_option_98.should_receive(:food_id).and_return("1")
    weight_option_98.should_receive(:weight_id).and_return("1")

    weight_option_99 = mock("weight_option_99")
    weight_option_99.stub!(:to_param).and_return("99")
    weight_option_99.should_receive(:food_id).and_return("1")
    weight_option_99.should_receive(:weight_id).and_return("1")

    assigns[:weight_options] = [weight_option_98, weight_option_99]
  end

  specify "should render list of weight_options" do
    render "/weight_options/index.rhtml"

  end
end

