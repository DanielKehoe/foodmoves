require File.dirname(__FILE__) + '/../../spec_helper'

context "/sizes/index.rhtml" do
  include SizesHelper
  
  setup do
    size_98 = mock("size_98")
    size_98.stub!(:to_param).and_return("98")
    size_98.should_receive(:name).and_return("MyString")

    size_99 = mock("size_99")
    size_99.stub!(:to_param).and_return("99")
    size_99.should_receive(:name).and_return("MyString")

    assigns[:sizes] = [size_98, size_99]
  end

  specify "should render list of sizes" do
    render "/sizes/index.rhtml"

    response.should_have_tag 'td', :content => "MyString"
  end
end

