require File.dirname(__FILE__) + '/../../spec_helper'

context "/weight_options/show.rhtml" do
  include WeightOptionsHelper
  
  setup do
    @weight_option = mock("weight_option")
    @weight_option.stub!(:to_param).and_return("99")
    @weight_option.stub!(:errors).and_return(@errors)
    @weight_option.stub!(:food_id).and_return("1")
    @weight_option.stub!(:weight_id).and_return("1")

    assigns[:weight_option] = @weight_option
  end

  specify "should render attributes in <p>" do
    render "/weight_options/show.rhtml"

  end
end

