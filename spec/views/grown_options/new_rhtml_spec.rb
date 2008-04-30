require File.dirname(__FILE__) + '/../../spec_helper'

context "/grown_options/new.rhtml" do
  include GrownOptionsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @grown_option = mock("grown_option")
    @grown_option.stub!(:to_param).and_return("99")
    @grown_option.stub!(:errors).and_return(@errors)
    @grown_option.stub!(:food_id).and_return("1")
    @grown_option.stub!(:grown_id).and_return("1")

    assigns[:grown_option] = @grown_option
  end

  specify "should render new form" do
    render "/grown_options/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => grown_options_path, :method => 'post'}

  end
end


