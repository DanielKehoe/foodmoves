require File.dirname(__FILE__) + '/../../spec_helper'

context "/qualities/edit.rhtml" do
  include QualitiesHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @quality = mock_model(Quality, :errors => @errors)
    @quality.stub!(:name).and_return("MyString")

    assigns[:quality] = @quality
  end

  specify "should render edit form" do
    render "/qualities/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => quality_path(@quality), :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'quality[name]'}
  end
end


