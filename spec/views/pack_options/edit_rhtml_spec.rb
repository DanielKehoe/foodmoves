require File.dirname(__FILE__) + '/../../spec_helper'

context "/pack_options/edit.rhtml" do
  include PackOptionsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @pack_option = mock_model(PackOption, :errors => @errors)
    @pack_option.stub!(:food_id).and_return("1")
    @pack_option.stub!(:pack_id).and_return("1")

    assigns[:pack_option] = @pack_option
  end

  specify "should render edit form" do
    render "/pack_options/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => pack_option_path(@pack_option), :method => 'post'}

  end
end


