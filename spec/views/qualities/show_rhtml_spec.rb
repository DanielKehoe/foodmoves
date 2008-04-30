require File.dirname(__FILE__) + '/../../spec_helper'

context "/qualities/show.rhtml" do
  include QualitiesHelper
  
  setup do
    @quality = mock("quality")
    @quality.stub!(:to_param).and_return("99")
    @quality.stub!(:errors).and_return(@errors)
    @quality.stub!(:name).and_return("MyString")

    assigns[:quality] = @quality
  end

  specify "should render attributes in <p>" do
    render "/qualities/show.rhtml"

    # response.should_have_tag('p', :content => "MyString")
  end
end

