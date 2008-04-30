require File.dirname(__FILE__) + '/../../spec_helper'

context "/growns/edit.rhtml" do
  include GrownsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @grown = mock_model(Grown, :errors => @errors)
    @grown.stub!(:name).and_return("MyString")

    assigns[:grown] = @grown
  end

  specify "should render edit form" do
    render "/growns/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => grown_path(@grown), :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'grown[name]'}
  end
end


