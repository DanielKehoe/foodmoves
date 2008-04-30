require File.dirname(__FILE__) + '/../../spec_helper'

context "/weight_options/edit.rhtml" do
  include WeightOptionsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @weight_option = mock_model(WeightOption, :errors => @errors)
    @weight_option.stub!(:food_id).and_return("1")
    @weight_option.stub!(:weight_id).and_return("1")

    assigns[:weight_option] = @weight_option
  end

  specify "should render edit form" do
    render "/weight_options/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => weight_option_path(@weight_option), :method => 'post'}

  end
end


