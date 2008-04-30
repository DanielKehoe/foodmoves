require File.dirname(__FILE__) + '/../../spec_helper'

context "/colors/index.rhtml" do
  include ColorsHelper
  
  setup do
    color_98 = mock("color_98")
    color_98.stub!(:to_param).and_return("98")
    color_98.should_receive(:name).and_return("MyString")

    color_99 = mock("color_99")
    color_99.stub!(:to_param).and_return("99")
    color_99.should_receive(:name).and_return("MyString")

    assigns[:colors] = [color_98, color_99]
  end

  specify "should render list of colors" do
    render "/colors/index.rhtml"

    response.should_have_tag 'td', :content => "MyString"
  end
end

