require File.dirname(__FILE__) + '/../spec_helper'

context "Requesting /assets using GET" do
  controller_name :user_assets

  setup do
    @asset = mock_model(Asset)
    @assets = mock('Assets Association')
    @assets_array = [@asset]
    @assets.should_receive(:find).with(:all).and_return(@assets_array)
    User.stub!(:find_by_param).and_return mock_model(User, :assets => @assets)
    Asset.stub!(:find).and_return(@asset)
  end
  
  def do_get
    get :index, :user_id => "joe"
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should render index.rhtml" do
    controller.should_render :index
    do_get
  end
  
  specify "should find all assets" do
    do_get
  end
  
  specify "should assign the found assets for the view" do
    do_get
    assigns(:assets).should equal(@assets_array)
  end
end

context "Requesting /assets.xml using GET" do
  controller_name :user_assets

  setup do
    @asset = mock_model(Asset, :to_xml => "XML")
    @assets = mock('Assets Association')
    @assets_array = [@asset]
    @assets.should_receive(:find).with(:all).and_return(@assets_array)
    User.stub!(:find_by_param).and_return mock_model(User, :assets => @assets)
    Asset.stub!(:find).and_return(@asset)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index, :user_id => "joe"
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all assets" do
    do_get
  end
  
  specify "should render the found assets as xml" do
    @assets_array.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /assets/1 using GET" do
  controller_name :user_assets

  setup do
    @asset = mock_model(Asset)
    Asset.stub!(:find).and_return(@asset)
    @assets = mock('Assets Association')
    @assets.should_receive(:find).with("1").and_return(@asset)
    User.stub!(:find_by_param).and_return mock_model(User, :assets => @assets)
  end
  
  def do_get
    get :show, :id => "1", :user_id => "joe"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should render show.rhtml" do
    controller.should_render :show
    do_get
  end
  
  specify "should find the asset requested" do
    do_get
  end
  
  specify "should assign the found asset for the view" do
    do_get
    assigns[:asset].should equal(@asset)
  end
end

context "Requesting /assets/1.xml using GET" do
  controller_name :user_assets

  setup do
    @asset = mock_model(Asset, :to_xml => "XML")
    Asset.stub!(:find).and_return(@asset)
    @assets = mock('Assets Association')
    @assets.should_receive(:find).with("1").and_return(@asset)
    User.stub!(:find_by_param).and_return mock_model(User, :assets => @assets)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1", :user_id => "joe"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the asset requested" do
    do_get
  end
  
  specify "should render the found asset as xml" do
    @asset.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /assets/new using GET" do
  controller_name :user_assets

  setup do
    @asset = mock_model(Asset)
    @assets = mock('Assets Association')
    @assets.should_receive(:build).and_return(@asset)
    User.stub!(:find_by_param).and_return mock_model(User, :assets => @assets)
  end
  
  def do_get
    get :new, :user_id => "joe"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should render new.rhtml" do
    controller.should_render :new
    do_get
  end
  
  specify "should create an new asset" do
    do_get
  end
  
  specify "should not save the new asset" do
    @asset.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new asset for the view" do
    do_get
    assigns[:asset].should be(@asset)
  end
end

context "Requesting /assets/1;edit using GET" do
  controller_name :user_assets

  setup do
    @asset = mock_model(Asset)
    Asset.stub!(:find).and_return(@asset)
    @assets = mock('Assets Association')
    @assets.should_receive(:find).with("1").and_return(@asset)
    User.stub!(:find_by_param).and_return mock_model(User, :assets => @assets, :to_param => 'joe')
    controller.stub!(:check_auth).and_return true
  end
  
  def do_get
    get :edit, :id => "1", :user_id => "joe"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should render edit.rhtml" do
    do_get
    controller.should_render :edit
  end
  
  specify "should find the asset requested" do
    do_get
  end
  
  specify "should assign the found Asset for the view" do
    do_get
    assigns[:asset].should equal(@asset)
  end
end

context "Requesting /assets using POST" do
  controller_name :user_assets

  setup do
    @asset = mock_model(Asset, :to_param => "1", :save => true)
    @assets = mock('Assets Association')
    @assets.stub!(:build).and_return @asset
    User.stub!(:find_by_param).and_return mock_model(User, :assets => @assets, :to_param => 'joe')
  end
  
  def do_post
    post :create, :asset => {:name => 'Asset'}, :user_id => "joe"
  end
  
  specify "should create a new asset" do
    @assets.should_receive(:build).with({'name' => 'Asset'}).and_return(@asset)
    do_post
  end

  specify "should redirect to the new asset" do
    do_post
    response.should redirect_to("http://test.host/users/joe/assets/1")
  end
end

context "Requesting /assets/1 using PUT" do
  controller_name :user_assets

  setup do
    @asset = mock_model(Asset, :to_param => "1", :update_attributes => true)
    Asset.stub!(:find).and_return(@asset)
    @assets = mock('Assets Association')
    @assets.should_receive(:find).with("1").and_return(@asset)
    User.stub!(:find_by_param).and_return mock_model(User, :assets => @assets, :to_param => 'joe')
    controller.stub!(:check_auth).and_return true
  end
  
  def do_update
    put :update, :id => "1", :user_id => "joe"
  end
  
  specify "should find the asset requested" do
    do_update
  end

  specify "should update the found asset" do
    @asset.should_receive(:update_attributes)
    do_update
    assigns(:asset).should equal(@asset)
  end

  specify "should assign the found asset for the view" do
    do_update
    assigns(:asset).should equal(@asset)
  end

  specify "should redirect to the asset" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/users/joe/assets/1"
  end
end

context "Requesting /assets/1 using DELETE" do
  controller_name :user_assets

  setup do
    @asset = mock_model(Asset, :to_param => "1", :destroy => true)
    Asset.stub!(:find).and_return(@asset)
    @assets = mock('Assets Association')
    @assets.should_receive(:find).with("1").and_return(@asset)
    User.stub!(:find_by_param).and_return mock_model(User, :assets => @assets, :to_param => 'joe')
    controller.stub!(:check_auth).and_return true
  end
  
  def do_delete
    delete :destroy, :id => "1", :user_id => "joe"
  end

  specify "should find the asset requested" do
    do_delete
  end
  
  specify "should call destroy on the found asset" do
    @asset.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the assets list" do
    do_delete
    response.should redirect_to("http://test.host/users/joe/assets")
  end
end