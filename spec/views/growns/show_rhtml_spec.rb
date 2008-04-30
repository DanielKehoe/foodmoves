require File.dirname(__FILE__) + '/../../spec_helper'

context "/growns/show.rhtml" do
  include GrownsHelper
  
  setup do
    @grown = mock("grown")
    @grown.stub!(:to_param).and_return("99")
    @grown.stub!(:errors).and_return(@errors)
    @grown.stub!(:name).and_return("MyString")

    assigns[:grown] = @grown
  end

  specify "should render attributes in <p>" do
    render "/growns/show.rhtml"

    # response.should_have_tag('p', :content => "MyString")
  end
end

