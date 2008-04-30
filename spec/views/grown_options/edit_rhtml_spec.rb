require File.dirname(__FILE__) + '/../../spec_helper'

context "/grown_options/edit.rhtml" do
  include GrownOptionsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @grown_option = mock_model(GrownOption, :errors => @errors)
    @grown_option.stub!(:food_id).and_return("1")
    @grown_option.stub!(:grown_id).and_return("1")

    assigns[:grown_option] = @grown_option
  end

  specify "should render edit form" do
    render "/grown_options/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => grown_option_path(@grown_option), :method => 'post'}

  end
end


