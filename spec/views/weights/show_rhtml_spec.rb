require File.dirname(__FILE__) + '/../../spec_helper'

context "/weights/show.rhtml" do
  include WeightsHelper
  
  setup do
    @weight = mock("weight")
    @weight.stub!(:to_param).and_return("99")
    @weight.stub!(:errors).and_return(@errors)
    @weight.stub!(:name).and_return("MyString")

    assigns[:weight] = @weight
  end

  specify "should render attributes in <p>" do
    render "/weights/show.rhtml"

    # response.should_have_tag('p', :content => "MyString")
  end
end

