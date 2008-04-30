require File.dirname(__FILE__) + '/../../spec_helper'

context "/qualities/index.rhtml" do
  include QualitiesHelper
  
  setup do
    quality_98 = mock("quality_98")
    quality_98.stub!(:to_param).and_return("98")
    quality_98.should_receive(:name).and_return("MyString")

    quality_99 = mock("quality_99")
    quality_99.stub!(:to_param).and_return("99")
    quality_99.should_receive(:name).and_return("MyString")

    assigns[:qualities] = [quality_98, quality_99]
  end

  specify "should render list of qualities" do
    render "/qualities/index.rhtml"

    response.should_have_tag 'td', :content => "MyString"
  end
end

