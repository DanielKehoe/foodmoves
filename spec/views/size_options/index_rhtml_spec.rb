require File.dirname(__FILE__) + '/../../spec_helper'

context "/size_options/index.rhtml" do
  include SizeOptionsHelper
  
  setup do
    size_option_98 = mock("size_option_98")
    size_option_98.stub!(:to_param).and_return("98")
    size_option_98.should_receive(:food_id).and_return("1")
    size_option_98.should_receive(:size_id).and_return("1")

    size_option_99 = mock("size_option_99")
    size_option_99.stub!(:to_param).and_return("99")
    size_option_99.should_receive(:food_id).and_return("1")
    size_option_99.should_receive(:size_id).and_return("1")

    assigns[:size_options] = [size_option_98, size_option_99]
  end

  specify "should render list of size_options" do
    render "/size_options/index.rhtml"

  end
end

