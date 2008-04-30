require File.dirname(__FILE__) + '/../spec_helper'

context "the UserAssetsHelper" do
  helper_name :user_assets

  setup do
    @attachable = mock_model(User, :login => 'JoeLogin')
  end
  
  specify "should return user login name" do
    attachable_name().should_eql "JoeLogin"
  end
end