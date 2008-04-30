require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the GrownsController should map" do
  controller_name :growns

  specify "{ :controller => 'growns', :action => 'index' } to /growns" do
    route_for(:controller => "growns", :action => "index").should == "/growns"
  end
  
  specify "{ :controller => 'growns', :action => 'new' } to /growns/new" do
    route_for(:controller => "growns", :action => "new").should == "/growns/new"
  end
  
  specify "{ :controller => 'growns', :action => 'show', :id => 1 } to /growns/1" do
    route_for(:controller => "growns", :action => "show", :id => 1).should == "/growns/1"
  end
  
  specify "{ :controller => 'growns', :action => 'edit', :id => 1 } to /growns/1;edit" do
    route_for(:controller => "growns", :action => "edit", :id => 1).should == "/growns/1;edit"
  end
  
  specify "{ :controller => 'growns', :action => 'update', :id => 1} to /growns/1" do
    route_for(:controller => "growns", :action => "update", :id => 1).should == "/growns/1"
  end
  
  specify "{ :controller => 'growns', :action => 'destroy', :id => 1} to /growns/1" do
    route_for(:controller => "growns", :action => "destroy", :id => 1).should == "/growns/1"
  end
end

context "Requesting /growns using GET" do
  controller_name :growns

  setup do
    @grown = mock_model(Grown)
    Grown.stub!(:find).and_return(@grown)
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
  
  specify "should find all growns" do
    Grown.should_receive(:find).with(:all).and_return([@grown])
    do_get
  end
  
  specify "should assign the found growns for the view" do
    do_get
    assigns[:growns].should equal(@grown)
  end
end

context "Requesting /growns.xml using GET" do
  controller_name :growns

  setup do
    @grown = mock_model(Grown, :to_xml => "XML")
    Grown.stub!(:find).and_return(@grown)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all growns" do
    Grown.should_receive(:find).with(:all).and_return([@grown])
    do_get
  end
  
  specify "should render the found growns as xml" do
    @grown.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /growns/1 using GET" do
  controller_name :growns

  setup do
    @grown = mock_model(Grown)
    Grown.stub!(:find).and_return(@grown)
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
  
  specify "should find the grown requested" do
    Grown.should_receive(:find).with("1").and_return(@grown)
    do_get
  end
  
  specify "should assign the found grown for the view" do
    do_get
    assigns[:grown].should equal(@grown)
  end
end

context "Requesting /growns/1.xml using GET" do
  controller_name :growns

  setup do
    @grown = mock_model(Grown, :to_xml => "XML")
    Grown.stub!(:find).and_return(@grown)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the grown requested" do
    Grown.should_receive(:find).with("1").and_return(@grown)
    do_get
  end
  
  specify "should render the found grown as xml" do
    @grown.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /growns/new using GET" do
  controller_name :growns

  setup do
    @grown = mock_model(Grown)
    Grown.stub!(:new).and_return(@grown)
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
  
  specify "should create an new grown" do
    Grown.should_receive(:new).and_return(@grown)
    do_get
  end
  
  specify "should not save the new grown" do
    @grown.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new grown for the view" do
    do_get
    assigns[:grown].should be(@grown)
  end
end

context "Requesting /growns/1;edit using GET" do
  controller_name :growns

  setup do
    @grown = mock_model(Grown)
    Grown.stub!(:find).and_return(@grown)
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
  
  specify "should find the grown requested" do
    Grown.should_receive(:find).and_return(@grown)
    do_get
  end
  
  specify "should assign the found Grown for the view" do
    do_get
    assigns[:grown].should equal(@grown)
  end
end

context "Requesting /growns using POST" do
  controller_name :growns

  setup do
    @grown = mock_model(Grown, :to_param => "1", :save => true)
    Grown.stub!(:new).and_return(@grown)
  end
  
  def do_post
    post :create, :grown => {:name => 'Grown'}
  end
  
  specify "should create a new grown" do
    Grown.should_receive(:new).with({'name' => 'Grown'}).and_return(@grown)
    do_post
  end

  specify "should redirect to the new grown" do
    do_post
    response.should redirect_to("http://test.host/growns/1")
  end
end

context "Requesting /growns/1 using PUT" do
  controller_name :growns

  setup do
    @grown = mock_model(Grown, :to_param => "1", :update_attributes => true)
    Grown.stub!(:find).and_return(@grown)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the grown requested" do
    Grown.should_receive(:find).with("1").and_return(@grown)
    do_update
  end

  specify "should update the found grown" do
    @grown.should_receive(:update_attributes)
    do_update
    assigns(:grown).should equal(@grown)
  end

  specify "should assign the found grown for the view" do
    do_update
    assigns(:grown).should equal(@grown)
  end

  specify "should redirect to the grown" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/growns/1"
  end
end

context "Requesting /growns/1 using DELETE" do
  controller_name :growns

  setup do
    @grown = mock_model(Grown, :destroy => true)
    Grown.stub!(:find).and_return(@grown)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the grown requested" do
    Grown.should_receive(:find).with("1").and_return(@grown)
    do_delete
  end
  
  specify "should call destroy on the found grown" do
    @grown.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the growns list" do
    do_delete
    response.should redirect_to("http://test.host/growns")
  end
end