require File.dirname(__FILE__) + '/../../spec_helper'

context "/members/edit.rhtml" do
  include MembersHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @member = mock_model(Member, :errors => @errors)
    @member.stub!(:email).and_return("MyString")

    assigns[:member] = @member
  end

  specify "should render edit form" do
    render "/members/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => member_path(@member), :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'member[email]'}
  end
end


