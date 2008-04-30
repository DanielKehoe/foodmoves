require File.dirname(__FILE__) + '/../spec_helper.rb'

# An example of how to dynamically add to setup methods by including a module.
module SetupApp
  def self.included(base)
    if base.class.name == 'Spec::Runner::ContextEvalModule'
      base.setup do 

        request.stub!(:ssl?).and_return(true)
        @user = mock_user

      end # setup
    end # if
  end # included
end

module SetupSSL
  
end

context "/session/new GET" do
  controller_name :session

  specify "should render new" do
    request.stub!(:ssl?).and_return(true)
    controller.should_render :new
    get :new
  end
  
  specify "should redirect to ssl" do
    request.stub!(:ssl?).and_return(false)
    controller.should_redirect_to "https://test.host/session/new"
    get :new
  end
end

context "/session POST without remember me" do
  controller_name :session
  include SetupApp

  setup do
    User.stub!(:authenticate).and_return(@user)
    # controller.stub!(:logged_in?).and_return(true)
  end

  specify 'should authenticate user' do
    User.should_receive(:authenticate).with('user', 'password').and_return(@user)
    post :create, :login => 'user', :password => 'password'
  end

  specify 'should login user' do
    controller.should_receive(:logged_in?).and_return(false, true)
    post :create
  end

  specify "should not remember me" do
    post :create
    response.cookies["auth_token"].should_be_nil
  end

  specify "should redirect to root" do
    controller.should_redirect_to 'https://test.host:80/'
    post :create
  end
end

context "/session POST with remember me" do
  controller_name :session
  include SetupApp
  
  setup do

    @ccookies = mock('cookies')
    User.stub!(:authenticate).and_return(@user)
    controller.stub!(:logged_in?).and_return(false, true)
    @user.stub!(:remember_me)
    controller.stub!(:cookies).and_return(@ccookies)

    @ccookies.stub!(:[]=)
    @ccookies.stub!(:[])
    @user.stub!(:remember_token).and_return('1111')
    @user.stub!(:remember_token_expires_at).and_return(Time.now)
  end

  specify "should remember me" do
    @user.should_receive(:remember_me)
    post :create, :login => "derek", :password => "password", :remember_me => "1"
  end    

  specify 'should create cookie' do
    @ccookies.should_receive(:[]=).with(:auth_token, { :value => '1111' , :expires => @user.remember_token_expires_at })
    post :create, :login => "derek", :password => "password", :remember_me => "1"
  end
end

context "/session POST when invalid" do
  controller_name :session
  include SetupApp

  setup do
    controller.stub!(:logged_in?).and_return(false, false)
    User.stub!(:authenticate).and_return(nil)
  end

  specify 'should authenticate user' do
    User.should_receive(:authenticate).with('user', 'password').and_return(nil)
    post :create, :login => 'user', :password => 'password'
  end

  specify 'should login user' do
    controller.should_receive(:logged_in?).and_return(false, false)
    post :create
  end

  specify "should not remember me" do
    post :create
    response.cookies["auth_token"].should_be_nil
  end

  specify "should render new" do
    controller.should_render :action => 'new'
    post :create
  end
end

context "/session DELETE" do
  controller_name :session
  include SetupApp

  setup do
    @ccookies = mock('cookies')
    controller.stub!(:current_user).and_return(@user)
    controller.stub!(:logged_in?).and_return(true, true)
    @user.stub!(:forget_me)
    controller.stub!(:cookies).and_return(@ccookies)
    @ccookies.stub!(:delete)
    @ccookies.stub!(:[])
    response.cookies.stub!(:delete)
    controller.stub!(:reset_session)
  end

  specify "should get current user" do
    controller.should_receive(:current_user).and_return(@user, @user)
    delete :destroy
  end

  specify 'should forget current user' do
    @user.should_receive(:forget_me)
    delete :destroy
  end

  specify "should delete token on logout" do
    @ccookies.should_receive(:delete).with(:auth_token)
    delete :destroy
  end

  specify 'should reset session' do 
    controller.should_receive(:reset_session)
    delete :destroy
  end

  specify "should redirect to root" do
    controller.should_redirect_to 'https://test.host:80/'
    delete :destroy
  end
end
