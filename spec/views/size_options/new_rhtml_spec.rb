require File.dirname(__FILE__) + '/../../spec_helper'

context "/size_options/new.rhtml" do
  include SizeOptionsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @size_option = mock("size_option")
    @size_option.stub!(:to_param).and_return("99")
    @size_option.stub!(:errors).and_return(@errors)
    @size_option.stub!(:food_id).and_return("1")
    @size_option.stub!(:size_id).and_return("1")

    assigns[:size_option] = @size_option
  end

  specify "should render new form" do
    render "/size_options/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => size_options_path, :method => 'post'}

  end
end


