require File.dirname(__FILE__) + '/../../spec_helper'

context "/pack_options/index.rhtml" do
  include PackOptionsHelper
  
  setup do
    pack_option_98 = mock("pack_option_98")
    pack_option_98.stub!(:to_param).and_return("98")
    pack_option_98.should_receive(:food_id).and_return("1")
    pack_option_98.should_receive(:pack_id).and_return("1")

    pack_option_99 = mock("pack_option_99")
    pack_option_99.stub!(:to_param).and_return("99")
    pack_option_99.should_receive(:food_id).and_return("1")
    pack_option_99.should_receive(:pack_id).and_return("1")

    assigns[:pack_options] = [pack_option_98, pack_option_99]
  end

  specify "should render list of pack_options" do
    render "/pack_options/index.rhtml"

  end
end

