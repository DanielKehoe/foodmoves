require File.dirname(__FILE__) + '/../../spec_helper'

context "/color_options/edit.rhtml" do
  include ColorOptionsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @color_option = mock_model(ColorOption, :errors => @errors)
    @color_option.stub!(:food_id).and_return("1")
    @color_option.stub!(:color_id).and_return("1")

    assigns[:color_option] = @color_option
  end

  specify "should render edit form" do
    render "/color_options/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => color_option_path(@color_option), :method => 'post'}

  end
end


