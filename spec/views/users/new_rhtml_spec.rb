require File.dirname(__FILE__) + '/../../spec_helper'

context "/users/new.rhtml" do
  include UsersHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @user = mock_user
    @user.stub!(:errors).and_return @errors
    assigns[:user] = @user
  end

  specify "should render new form" do
    render "/users/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => users_path, :method => 'post'}

  end
end


