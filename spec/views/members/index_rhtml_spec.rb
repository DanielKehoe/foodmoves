require File.dirname(__FILE__) + '/../../spec_helper'

context "/members/index.rhtml" do
  include MembersHelper
  
  setup do
    member_98 = mock("member_98")
    member_98.stub!(:to_param).and_return("98")
    member_98.should_receive(:email).and_return("MyString")

    member_99 = mock("member_99")
    member_99.stub!(:to_param).and_return("99")
    member_99.should_receive(:email).and_return("MyString")

    assigns[:members] = [member_98, member_99]
  end

  specify "should render list of members" do
    render "/members/index.rhtml"

    response.should_have_tag 'td', :content => "MyString"
  end
end

