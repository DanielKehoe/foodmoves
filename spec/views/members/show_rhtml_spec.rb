require File.dirname(__FILE__) + '/../../spec_helper'

context "/members/show.rhtml" do
  include MembersHelper
  
  setup do
    @member = mock("member")
    @member.stub!(:to_param).and_return("99")
    @member.stub!(:errors).and_return(@errors)
    @member.stub!(:email).and_return("MyString")

    assigns[:member] = @member
  end

  specify "should render attributes in <p>" do
    render "/members/show.rhtml"

    # response.should_have_tag('p', :content => "MyString")
  end
end

