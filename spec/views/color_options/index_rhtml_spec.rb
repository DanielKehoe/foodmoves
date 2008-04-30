require File.dirname(__FILE__) + '/../../spec_helper'

context "/color_options/index.rhtml" do
  include ColorOptionsHelper
  
  setup do
    color_option_98 = mock("color_option_98")
    color_option_98.stub!(:to_param).and_return("98")
    color_option_98.should_receive(:food_id).and_return("1")
    color_option_98.should_receive(:color_id).and_return("1")

    color_option_99 = mock("color_option_99")
    color_option_99.stub!(:to_param).and_return("99")
    color_option_99.should_receive(:food_id).and_return("1")
    color_option_99.should_receive(:color_id).and_return("1")

    assigns[:color_options] = [color_option_98, color_option_99]
  end

  specify "should render list of color_options" do
    render "/color_options/index.rhtml"

  end
end

