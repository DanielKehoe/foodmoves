require File.dirname(__FILE__) + '/../../spec_helper'

context "/colors/edit.rhtml" do
  include ColorsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @color = mock_model(Color, :errors => @errors)
    @color.stub!(:name).and_return("MyString")

    assigns[:color] = @color
  end

  specify "should render edit form" do
    render "/colors/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => color_path(@color), :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'color[name]'}
  end
end


