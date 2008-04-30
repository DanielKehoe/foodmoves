require File.dirname(__FILE__) + '/../../spec_helper'

context "/sizes/edit.rhtml" do
  include SizesHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @size = mock_model(Size, :errors => @errors)
    @size.stub!(:name).and_return("MyString")

    assigns[:size] = @size
  end

  specify "should render edit form" do
    render "/sizes/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => size_path(@size), :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'size[name]'}
  end
end


