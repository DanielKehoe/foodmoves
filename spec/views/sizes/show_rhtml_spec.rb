require File.dirname(__FILE__) + '/../../spec_helper'

context "/sizes/show.rhtml" do
  include SizesHelper
  
  setup do
    @size = mock("size")
    @size.stub!(:to_param).and_return("99")
    @size.stub!(:errors).and_return(@errors)
    @size.stub!(:name).and_return("MyString")

    assigns[:size] = @size
  end

  specify "should render attributes in <p>" do
    render "/sizes/show.rhtml"

    # response.should_have_tag('p', :content => "MyString")
  end
end

