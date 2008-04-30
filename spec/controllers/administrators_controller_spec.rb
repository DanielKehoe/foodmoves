require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the AdministratorsController should map" do
  controller_name :administrators

  specify "{ :controller => 'administrators', :action => 'index' } to /administrators" do
    route_for(:controller => "administrators", :action => "index").should == "/administrators"
  end
  
  specify "{ :controller => 'administrators', :action => 'new' } to /administrators/new" do
    route_for(:controller => "administrators", :action => "new").should == "/administrators/new"
  end
  
  specify "{ :controller => 'administrators', :action => 'show', :id => 1 } to /administrators/1" do
    route_for(:controller => "administrators", :action => "show", :id => 1).should == "/administrators/1"
  end
  
  specify "{ :controller => 'administrators', :action => 'edit', :id => 1 } to /administrators/1;edit" do
    route_for(:controller => "administrators", :action => "edit", :id => 1).should == "/administrators/1;edit"
  end
  
  specify "{ :controller => 'administrators', :action => 'update', :id => 1} to /administrators/1" do
    route_for(:controller => "administrators", :action => "update", :id => 1).should == "/administrators/1"
  end
  
  specify "{ :controller => 'administrators', :action => 'destroy', :id => 1} to /administrators/1" do
    route_for(:controller => "administrators", :action => "destroy", :id => 1).should == "/administrators/1"
  end
end

context "Requesting /administrators using GET" do
  controller_name :administrators

  setup do
    @administrator = mock_model(Administrator)
    Administrator.stub!(:find).and_return(@administrator)
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
  
  specify "should find all administrators" do
    Administrator.should_receive(:find).with(:all).and_return([@administrator])
    do_get
  end
  
  specify "should assign the found administrators for the view" do
    do_get
    assigns[:administrators].should equal(@administrator)
  end
end

context "Requesting /administrators.xml using GET" do
  controller_name :administrators

  setup do
    @administrator = mock_model(Administrator, :to_xml => "XML")
    Administrator.stub!(:find).and_return(@administrator)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all administrators" do
    Administrator.should_receive(:find).with(:all).and_return([@administrator])
    do_get
  end
  
  specify "should render the found administrators as xml" do
    @administrator.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /administrators/1 using GET" do
  controller_name :administrators

  setup do
    @administrator = mock_model(Administrator)
    Administrator.stub!(:find).and_return(@administrator)
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
  
  specify "should find the administrator requested" do
    Administrator.should_receive(:find).with("1").and_return(@administrator)
    do_get
  end
  
  specify "should assign the found administrator for the view" do
    do_get
    assigns[:administrator].should equal(@administrator)
  end
end

context "Requesting /administrators/1.xml using GET" do
  controller_name :administrators

  setup do
    @administrator = mock_model(Administrator, :to_xml => "XML")
    Administrator.stub!(:find).and_return(@administrator)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the administrator requested" do
    Administrator.should_receive(:find).with("1").and_return(@administrator)
    do_get
  end
  
  specify "should render the found administrator as xml" do
    @administrator.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /administrators/new using GET" do
  controller_name :administrators

  setup do
    @administrator = mock_model(Administrator)
    Administrator.stub!(:new).and_return(@administrator)
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
  
  specify "should create an new administrator" do
    Administrator.should_receive(:new).and_return(@administrator)
    do_get
  end
  
  specify "should not save the new administrator" do
    @administrator.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new administrator for the view" do
    do_get
    assigns[:administrator].should be(@administrator)
  end
end

context "Requesting /administrators/1;edit using GET" do
  controller_name :administrators

  setup do
    @administrator = mock_model(Administrator)
    Administrator.stub!(:find).and_return(@administrator)
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
  
  specify "should find the administrator requested" do
    Administrator.should_receive(:find).and_return(@administrator)
    do_get
  end
  
  specify "should assign the found Administrator for the view" do
    do_get
    assigns[:administrator].should equal(@administrator)
  end
end

context "Requesting /administrators using POST" do
  controller_name :administrators

  setup do
    @administrator = mock_model(Administrator, :to_param => "1", :save => true)
    Administrator.stub!(:new).and_return(@administrator)
  end
  
  def do_post
    post :create, :administrator => {:name => 'Administrator'}
  end
  
  specify "should create a new administrator" do
    Administrator.should_receive(:new).with({'name' => 'Administrator'}).and_return(@administrator)
    do_post
  end

  specify "should redirect to the new administrator" do
    do_post
    response.should redirect_to("http://test.host/administrators/1")
  end
end

context "Requesting /administrators/1 using PUT" do
  controller_name :administrators

  setup do
    @administrator = mock_model(Administrator, :to_param => "1", :update_attributes => true)
    Administrator.stub!(:find).and_return(@administrator)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the administrator requested" do
    Administrator.should_receive(:find).with("1").and_return(@administrator)
    do_update
  end

  specify "should update the found administrator" do
    @administrator.should_receive(:update_attributes)
    do_update
    assigns(:administrator).should equal(@administrator)
  end

  specify "should assign the found administrator for the view" do
    do_update
    assigns(:administrator).should equal(@administrator)
  end

  specify "should redirect to the administrator" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/administrators/1"
  end
end

context "Requesting /administrators/1 using DELETE" do
  controller_name :administrators

  setup do
    @administrator = mock_model(Administrator, :destroy => true)
    Administrator.stub!(:find).and_return(@administrator)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the administrator requested" do
    Administrator.should_receive(:find).with("1").and_return(@administrator)
    do_delete
  end
  
  specify "should call destroy on the found administrator" do
    @administrator.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the administrators list" do
    do_delete
    response.should redirect_to("http://test.host/administrators")
  end
end