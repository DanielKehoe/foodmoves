require File.dirname(__FILE__) + '/../../spec_helper'

context "/colors/show.rhtml" do
  include ColorsHelper
  
  setup do
    @color = mock("color")
    @color.stub!(:to_param).and_return("99")
    @color.stub!(:errors).and_return(@errors)
    @color.stub!(:name).and_return("MyString")

    assigns[:color] = @color
  end

  specify "should render attributes in <p>" do
    render "/colors/show.rhtml"

    # response.should_have_tag('p', :content => "MyString")
  end
end

