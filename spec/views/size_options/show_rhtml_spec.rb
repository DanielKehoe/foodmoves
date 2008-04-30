require File.dirname(__FILE__) + '/../../spec_helper'

context "/size_options/show.rhtml" do
  include SizeOptionsHelper
  
  setup do
    @size_option = mock("size_option")
    @size_option.stub!(:to_param).and_return("99")
    @size_option.stub!(:errors).and_return(@errors)
    @size_option.stub!(:food_id).and_return("1")
    @size_option.stub!(:size_id).and_return("1")

    assigns[:size_option] = @size_option
  end

  specify "should render attributes in <p>" do
    render "/size_options/show.rhtml"

  end
end

