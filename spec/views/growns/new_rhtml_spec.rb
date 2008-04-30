require File.dirname(__FILE__) + '/../../spec_helper'

context "/growns/new.rhtml" do
  include GrownsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @grown = mock("grown")
    @grown.stub!(:to_param).and_return("99")
    @grown.stub!(:errors).and_return(@errors)
    @grown.stub!(:name).and_return("MyString")

    assigns[:grown] = @grown
  end

  specify "should render new form" do
    render "/growns/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => growns_path, :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'grown[name]'}
  end
end


