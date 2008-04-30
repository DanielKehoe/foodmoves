require File.dirname(__FILE__) + '/../../spec_helper'

context "/size_options/edit.rhtml" do
  include SizeOptionsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @size_option = mock_model(SizeOption, :errors => @errors)
    @size_option.stub!(:food_id).and_return("1")
    @size_option.stub!(:size_id).and_return("1")

    assigns[:size_option] = @size_option
  end

  specify "should render edit form" do
    render "/size_options/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => size_option_path(@size_option), :method => 'post'}

  end
end


