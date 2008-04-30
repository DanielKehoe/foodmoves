require File.dirname(__FILE__) + '/../../spec_helper'

context "/grown_options/show.rhtml" do
  include GrownOptionsHelper
  
  setup do
    @grown_option = mock("grown_option")
    @grown_option.stub!(:to_param).and_return("99")
    @grown_option.stub!(:errors).and_return(@errors)
    @grown_option.stub!(:food_id).and_return("1")
    @grown_option.stub!(:grown_id).and_return("1")

    assigns[:grown_option] = @grown_option
  end

  specify "should render attributes in <p>" do
    render "/grown_options/show.rhtml"

  end
end

