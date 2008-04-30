require File.dirname(__FILE__) + '/../../spec_helper'

context "/color_options/show.rhtml" do
  include ColorOptionsHelper
  
  setup do
    @color_option = mock("color_option")
    @color_option.stub!(:to_param).and_return("99")
    @color_option.stub!(:errors).and_return(@errors)
    @color_option.stub!(:food_id).and_return("1")
    @color_option.stub!(:color_id).and_return("1")

    assigns[:color_option] = @color_option
  end

  specify "should render attributes in <p>" do
    render "/color_options/show.rhtml"

  end
end

