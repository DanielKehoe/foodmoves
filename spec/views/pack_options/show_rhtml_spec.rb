require File.dirname(__FILE__) + '/../../spec_helper'

context "/pack_options/show.rhtml" do
  include PackOptionsHelper
  
  setup do
    @pack_option = mock("pack_option")
    @pack_option.stub!(:to_param).and_return("99")
    @pack_option.stub!(:errors).and_return(@errors)
    @pack_option.stub!(:food_id).and_return("1")
    @pack_option.stub!(:pack_id).and_return("1")

    assigns[:pack_option] = @pack_option
  end

  specify "should render attributes in <p>" do
    render "/pack_options/show.rhtml"

  end
end

