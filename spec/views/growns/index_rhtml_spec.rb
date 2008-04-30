require File.dirname(__FILE__) + '/../../spec_helper'

context "/growns/index.rhtml" do
  include GrownsHelper
  
  setup do
    grown_98 = mock("grown_98")
    grown_98.stub!(:to_param).and_return("98")
    grown_98.should_receive(:name).and_return("MyString")

    grown_99 = mock("grown_99")
    grown_99.stub!(:to_param).and_return("99")
    grown_99.should_receive(:name).and_return("MyString")

    assigns[:growns] = [grown_98, grown_99]
  end

  specify "should render list of growns" do
    render "/growns/index.rhtml"

    response.should_have_tag 'td', :content => "MyString"
  end
end

