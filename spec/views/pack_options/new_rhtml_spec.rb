require File.dirname(__FILE__) + '/../../spec_helper'

context "/pack_options/new.rhtml" do
  include PackOptionsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @pack_option = mock("pack_option")
    @pack_option.stub!(:to_param).and_return("99")
    @pack_option.stub!(:errors).and_return(@errors)
    @pack_option.stub!(:food_id).and_return("1")
    @pack_option.stub!(:pack_id).and_return("1")

    assigns[:pack_option] = @pack_option
  end

  specify "should render new form" do
    render "/pack_options/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => pack_options_path, :method => 'post'}

  end
end


