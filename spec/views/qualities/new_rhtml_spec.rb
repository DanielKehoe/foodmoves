require File.dirname(__FILE__) + '/../../spec_helper'

context "/qualities/new.rhtml" do
  include QualitiesHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @quality = mock("quality")
    @quality.stub!(:to_param).and_return("99")
    @quality.stub!(:errors).and_return(@errors)
    @quality.stub!(:name).and_return("MyString")

    assigns[:quality] = @quality
  end

  specify "should render new form" do
    render "/qualities/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => qualities_path, :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'quality[name]'}
  end
end


