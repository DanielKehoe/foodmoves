require File.dirname(__FILE__) + '/../../spec_helper'

context "/members/new.rhtml" do
  include MembersHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @member = mock("member")
    @member.stub!(:to_param).and_return("99")
    @member.stub!(:errors).and_return(@errors)
    @member.stub!(:email).and_return("MyString")

    assigns[:member] = @member
  end

  specify "should render new form" do
    render "/members/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => members_path, :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'member[email]'}
  end
end


