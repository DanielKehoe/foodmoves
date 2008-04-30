require File.dirname(__FILE__) + '/../../spec_helper'

context "/weights/index.rhtml" do
  include WeightsHelper
  
  setup do
    weight_98 = mock("weight_98")
    weight_98.stub!(:to_param).and_return("98")
    weight_98.should_receive(:name).and_return("MyString")

    weight_99 = mock("weight_99")
    weight_99.stub!(:to_param).and_return("99")
    weight_99.should_receive(:name).and_return("MyString")

    assigns[:weights] = [weight_98, weight_99]
  end

  specify "should render list of weights" do
    render "/weights/index.rhtml"

    response.should_have_tag 'td', :content => "MyString"
  end
end

