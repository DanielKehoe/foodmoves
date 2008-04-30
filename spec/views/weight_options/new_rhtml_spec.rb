require File.dirname(__FILE__) + '/../../spec_helper'

context "/weight_options/new.rhtml" do
  include WeightOptionsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @weight_option = mock("weight_option")
    @weight_option.stub!(:to_param).and_return("99")
    @weight_option.stub!(:errors).and_return(@errors)
    @weight_option.stub!(:food_id).and_return("1")
    @weight_option.stub!(:weight_id).and_return("1")

    assigns[:weight_option] = @weight_option
  end

  specify "should render new form" do
    render "/weight_options/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => weight_options_path, :method => 'post'}

  end
end


