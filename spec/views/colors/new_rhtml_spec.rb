require File.dirname(__FILE__) + '/../../spec_helper'

context "/colors/new.rhtml" do
  include ColorsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @color = mock("color")
    @color.stub!(:to_param).and_return("99")
    @color.stub!(:errors).and_return(@errors)
    @color.stub!(:name).and_return("MyString")

    assigns[:color] = @color
  end

  specify "should render new form" do
    render "/colors/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => colors_path, :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'color[name]'}
  end
end


