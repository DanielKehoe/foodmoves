require File.dirname(__FILE__) + '/../../spec_helper'

context "/sizes/new.rhtml" do
  include SizesHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @size = mock("size")
    @size.stub!(:to_param).and_return("99")
    @size.stub!(:errors).and_return(@errors)
    @size.stub!(:name).and_return("MyString")

    assigns[:size] = @size
  end

  specify "should render new form" do
    render "/sizes/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => sizes_path, :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'size[name]'}
  end
end


