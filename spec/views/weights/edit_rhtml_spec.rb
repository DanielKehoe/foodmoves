require File.dirname(__FILE__) + '/../../spec_helper'

context "/weights/edit.rhtml" do
  include WeightsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @weight = mock_model(Weight, :errors => @errors)
    @weight.stub!(:name).and_return("MyString")

    assigns[:weight] = @weight
  end

  specify "should render edit form" do
    render "/weights/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => weight_path(@weight), :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'weight[name]'}
  end
end


