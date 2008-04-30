require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the PermissionsController should map" do
  controller_name :permissions

  specify "{ :controller => 'permissions', :action => 'index' } to /permissions" do
    route_for(:controller => "permissions", :action => "index").should == "/permissions"
  end
  
  specify "{ :controller => 'permissions', :action => 'new' } to /permissions/new" do
    route_for(:controller => "permissions", :action => "new").should == "/permissions/new"
  end
  
  specify "{ :controller => 'permissions', :action => 'show', :id => 1 } to /permissions/1" do
    route_for(:controller => "permissions", :action => "show", :id => 1).should == "/permissions/1"
  end
  
  specify "{ :controller => 'permissions', :action => 'edit', :id => 1 } to /permissions/1;edit" do
    route_for(:controller => "permissions", :action => "edit", :id => 1).should == "/permissions/1;edit"
  end
  
  specify "{ :controller => 'permissions', :action => 'update', :id => 1} to /permissions/1" do
    route_for(:controller => "permissions", :action => "update", :id => 1).should == "/permissions/1"
  end
  
  specify "{ :controller => 'permissions', :action => 'destroy', :id => 1} to /permissions/1" do
    route_for(:controller => "permissions", :action => "destroy", :id => 1).should == "/permissions/1"
  end
end

context "Requesting /permissions using GET" do
  controller_name :permissions

  setup do
    @permission = mock_model(Permission)
    Permission.stub!(:find).and_return(@permission)
  end
  
  def do_get
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should render index.rhtml" do
    controller.should_render :index
    do_get
  end
  
  specify "should find all permissions" do
    Permission.should_receive(:find).with(:all).and_return([@permission])
    do_get
  end
  
  specify "should assign the found permissions for the view" do
    do_get
    assigns[:permissions].should equal(@permission)
  end
end

context "Requesting /permissions.xml using GET" do
  controller_name :permissions

  setup do
    @permission = mock_model(Permission, :to_xml => "XML")
    Permission.stub!(:find).and_return(@permission)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all permissions" do
    Permission.should_receive(:find).with(:all).and_return([@permission])
    do_get
  end
  
  specify "should render the found permissions as xml" do
    @permission.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /permissions/1 using GET" do
  controller_name :permissions

  setup do
    @permission = mock_model(Permission)
    Permission.stub!(:find).and_return(@permission)
  end
  
  def do_get
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should render show.rhtml" do
    controller.should_render :show
    do_get
  end
  
  specify "should find the permission requested" do
    Permission.should_receive(:find).with("1").and_return(@permission)
    do_get
  end
  
  specify "should assign the found permission for the view" do
    do_get
    assigns[:permission].should equal(@permission)
  end
end

context "Requesting /permissions/1.xml using GET" do
  controller_name :permissions

  setup do
    @permission = mock_model(Permission, :to_xml => "XML")
    Permission.stub!(:find).and_return(@permission)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the permission requested" do
    Permission.should_receive(:find).with("1").and_return(@permission)
    do_get
  end
  
  specify "should render the found permission as xml" do
    @permission.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /permissions/new using GET" do
  controller_name :permissions

  setup do
    @permission = mock_model(Permission)
    Permission.stub!(:new).and_return(@permission)
  end
  
  def do_get
    get :new
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should render new.rhtml" do
    controller.should_render :new
    do_get
  end
  
  specify "should create an new permission" do
    Permission.should_receive(:new).and_return(@permission)
    do_get
  end
  
  specify "should not save the new permission" do
    @permission.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new permission for the view" do
    do_get
    assigns[:permission].should be(@permission)
  end
end

context "Requesting /permissions/1;edit using GET" do
  controller_name :permissions

  setup do
    @permission = mock_model(Permission)
    Permission.stub!(:find).and_return(@permission)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should render edit.rhtml" do
    do_get
    controller.should_render :edit
  end
  
  specify "should find the permission requested" do
    Permission.should_receive(:find).and_return(@permission)
    do_get
  end
  
  specify "should assign the found Permission for the view" do
    do_get
    assigns[:permission].should equal(@permission)
  end
end

context "Requesting /permissions using POST" do
  controller_name :permissions

  setup do
    @permission = mock_model(Permission, :to_param => "1", :save => true)
    Permission.stub!(:new).and_return(@permission)
  end
  
  def do_post
    post :create, :permission => {:name => 'Permission'}
  end
  
  specify "should create a new permission" do
    Permission.should_receive(:new).with({'name' => 'Permission'}).and_return(@permission)
    do_post
  end

  specify "should redirect to the new permission" do
    do_post
    response.should redirect_to("http://test.host/permissions/1")
  end
end

context "Requesting /permissions/1 using PUT" do
  controller_name :permissions

  setup do
    @permission = mock_model(Permission, :to_param => "1", :update_attributes => true)
    Permission.stub!(:find).and_return(@permission)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the permission requested" do
    Permission.should_receive(:find).with("1").and_return(@permission)
    do_update
  end

  specify "should update the found permission" do
    @permission.should_receive(:update_attributes)
    do_update
    assigns(:permission).should equal(@permission)
  end

  specify "should assign the found permission for the view" do
    do_update
    assigns(:permission).should equal(@permission)
  end

  specify "should redirect to the permission" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/permissions/1"
  end
end

context "Requesting /permissions/1 using DELETE" do
  controller_name :permissions

  setup do
    @permission = mock_model(Permission, :destroy => true)
    Permission.stub!(:find).and_return(@permission)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the permission requested" do
    Permission.should_receive(:find).with("1").and_return(@permission)
    do_delete
  end
  
  specify "should call destroy on the found permission" do
    @permission.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the permissions list" do
    do_delete
    response.should redirect_to("http://test.host/permissions")
  end
end