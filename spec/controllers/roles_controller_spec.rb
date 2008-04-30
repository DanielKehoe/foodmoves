require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the RolesController should map" do
  controller_name :roles

  specify "{ :controller => 'roles', :action => 'index' } to /roles" do
    route_for(:controller => "roles", :action => "index").should == "/roles"
  end
  
  specify "{ :controller => 'roles', :action => 'new' } to /roles/new" do
    route_for(:controller => "roles", :action => "new").should == "/roles/new"
  end
  
  specify "{ :controller => 'roles', :action => 'show', :id => 1 } to /roles/1" do
    route_for(:controller => "roles", :action => "show", :id => 1).should == "/roles/1"
  end
  
  specify "{ :controller => 'roles', :action => 'edit', :id => 1 } to /roles/1;edit" do
    route_for(:controller => "roles", :action => "edit", :id => 1).should == "/roles/1;edit"
  end
  
  specify "{ :controller => 'roles', :action => 'update', :id => 1} to /roles/1" do
    route_for(:controller => "roles", :action => "update", :id => 1).should == "/roles/1"
  end
  
  specify "{ :controller => 'roles', :action => 'destroy', :id => 1} to /roles/1" do
    route_for(:controller => "roles", :action => "destroy", :id => 1).should == "/roles/1"
  end
end

context "Requesting /roles using GET" do
  controller_name :roles

  setup do
    @role = mock_model(Role)
    Role.stub!(:find).and_return(@role)
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
  
  specify "should find all roles" do
    Role.should_receive(:find).with(:all).and_return([@role])
    do_get
  end
  
  specify "should assign the found roles for the view" do
    do_get
    assigns[:roles].should equal(@role)
  end
end

context "Requesting /roles.xml using GET" do
  controller_name :roles

  setup do
    @role = mock_model(Role, :to_xml => "XML")
    Role.stub!(:find).and_return(@role)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all roles" do
    Role.should_receive(:find).with(:all).and_return([@role])
    do_get
  end
  
  specify "should render the found roles as xml" do
    @role.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /roles/1 using GET" do
  controller_name :roles

  setup do
    @role = mock_model(Role)
    Role.stub!(:find).and_return(@role)
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
  
  specify "should find the role requested" do
    Role.should_receive(:find).with("1").and_return(@role)
    do_get
  end
  
  specify "should assign the found role for the view" do
    do_get
    assigns[:role].should equal(@role)
  end
end

context "Requesting /roles/1.xml using GET" do
  controller_name :roles

  setup do
    @role = mock_model(Role, :to_xml => "XML")
    Role.stub!(:find).and_return(@role)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the role requested" do
    Role.should_receive(:find).with("1").and_return(@role)
    do_get
  end
  
  specify "should render the found role as xml" do
    @role.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /roles/new using GET" do
  controller_name :roles

  setup do
    @role = mock_model(Role)
    Role.stub!(:new).and_return(@role)
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
  
  specify "should create an new role" do
    Role.should_receive(:new).and_return(@role)
    do_get
  end
  
  specify "should not save the new role" do
    @role.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new role for the view" do
    do_get
    assigns[:role].should be(@role)
  end
end

context "Requesting /roles/1;edit using GET" do
  controller_name :roles

  setup do
    @role = mock_model(Role)
    Role.stub!(:find).and_return(@role)
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
  
  specify "should find the role requested" do
    Role.should_receive(:find).and_return(@role)
    do_get
  end
  
  specify "should assign the found Role for the view" do
    do_get
    assigns[:role].should equal(@role)
  end
end

context "Requesting /roles using POST" do
  controller_name :roles

  setup do
    @role = mock_model(Role, :to_param => "1", :save => true)
    Role.stub!(:new).and_return(@role)
  end
  
  def do_post
    post :create, :role => {:name => 'Role'}
  end
  
  specify "should create a new role" do
    Role.should_receive(:new).with({'name' => 'Role'}).and_return(@role)
    do_post
  end

  specify "should redirect to the new role" do
    do_post
    response.should redirect_to("http://test.host/roles/1")
  end
end

context "Requesting /roles/1 using PUT" do
  controller_name :roles

  setup do
    @role = mock_model(Role, :to_param => "1", :update_attributes => true)
    Role.stub!(:find).and_return(@role)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the role requested" do
    Role.should_receive(:find).with("1").and_return(@role)
    do_update
  end

  specify "should update the found role" do
    @role.should_receive(:update_attributes)
    do_update
    assigns(:role).should equal(@role)
  end

  specify "should assign the found role for the view" do
    do_update
    assigns(:role).should equal(@role)
  end

  specify "should redirect to the role" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/roles/1"
  end
end

context "Requesting /roles/1 using DELETE" do
  controller_name :roles

  setup do
    @role = mock_model(Role, :destroy => true)
    Role.stub!(:find).and_return(@role)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the role requested" do
    Role.should_receive(:find).with("1").and_return(@role)
    do_delete
  end
  
  specify "should call destroy on the found role" do
    @role.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the roles list" do
    do_delete
    response.should redirect_to("http://test.host/roles")
  end
end