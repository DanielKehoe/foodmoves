require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the PacksController should map" do
  controller_name :packs

  specify "{ :controller => 'packs', :action => 'index' } to /packs" do
    route_for(:controller => "packs", :action => "index").should == "/packs"
  end
  
  specify "{ :controller => 'packs', :action => 'new' } to /packs/new" do
    route_for(:controller => "packs", :action => "new").should == "/packs/new"
  end
  
  specify "{ :controller => 'packs', :action => 'show', :id => 1 } to /packs/1" do
    route_for(:controller => "packs", :action => "show", :id => 1).should == "/packs/1"
  end
  
  specify "{ :controller => 'packs', :action => 'edit', :id => 1 } to /packs/1;edit" do
    route_for(:controller => "packs", :action => "edit", :id => 1).should == "/packs/1;edit"
  end
  
  specify "{ :controller => 'packs', :action => 'update', :id => 1} to /packs/1" do
    route_for(:controller => "packs", :action => "update", :id => 1).should == "/packs/1"
  end
  
  specify "{ :controller => 'packs', :action => 'destroy', :id => 1} to /packs/1" do
    route_for(:controller => "packs", :action => "destroy", :id => 1).should == "/packs/1"
  end
end

context "Requesting /packs using GET" do
  controller_name :packs

  setup do
    @pack = mock_model(Pack)
    Pack.stub!(:find).and_return(@pack)
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
  
  specify "should find all packs" do
    Pack.should_receive(:find).with(:all).and_return([@pack])
    do_get
  end
  
  specify "should assign the found packs for the view" do
    do_get
    assigns[:packs].should equal(@pack)
  end
end

context "Requesting /packs.xml using GET" do
  controller_name :packs

  setup do
    @pack = mock_model(Pack, :to_xml => "XML")
    Pack.stub!(:find).and_return(@pack)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all packs" do
    Pack.should_receive(:find).with(:all).and_return([@pack])
    do_get
  end
  
  specify "should render the found packs as xml" do
    @pack.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /packs/1 using GET" do
  controller_name :packs

  setup do
    @pack = mock_model(Pack)
    Pack.stub!(:find).and_return(@pack)
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
  
  specify "should find the pack requested" do
    Pack.should_receive(:find).with("1").and_return(@pack)
    do_get
  end
  
  specify "should assign the found pack for the view" do
    do_get
    assigns[:pack].should equal(@pack)
  end
end

context "Requesting /packs/1.xml using GET" do
  controller_name :packs

  setup do
    @pack = mock_model(Pack, :to_xml => "XML")
    Pack.stub!(:find).and_return(@pack)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the pack requested" do
    Pack.should_receive(:find).with("1").and_return(@pack)
    do_get
  end
  
  specify "should render the found pack as xml" do
    @pack.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /packs/new using GET" do
  controller_name :packs

  setup do
    @pack = mock_model(Pack)
    Pack.stub!(:new).and_return(@pack)
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
  
  specify "should create an new pack" do
    Pack.should_receive(:new).and_return(@pack)
    do_get
  end
  
  specify "should not save the new pack" do
    @pack.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new pack for the view" do
    do_get
    assigns[:pack].should be(@pack)
  end
end

context "Requesting /packs/1;edit using GET" do
  controller_name :packs

  setup do
    @pack = mock_model(Pack)
    Pack.stub!(:find).and_return(@pack)
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
  
  specify "should find the pack requested" do
    Pack.should_receive(:find).and_return(@pack)
    do_get
  end
  
  specify "should assign the found Pack for the view" do
    do_get
    assigns[:pack].should equal(@pack)
  end
end

context "Requesting /packs using POST" do
  controller_name :packs

  setup do
    @pack = mock_model(Pack, :to_param => "1", :save => true)
    Pack.stub!(:new).and_return(@pack)
  end
  
  def do_post
    post :create, :pack => {:name => 'Pack'}
  end
  
  specify "should create a new pack" do
    Pack.should_receive(:new).with({'name' => 'Pack'}).and_return(@pack)
    do_post
  end

  specify "should redirect to the new pack" do
    do_post
    response.should redirect_to("http://test.host/packs/1")
  end
end

context "Requesting /packs/1 using PUT" do
  controller_name :packs

  setup do
    @pack = mock_model(Pack, :to_param => "1", :update_attributes => true)
    Pack.stub!(:find).and_return(@pack)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the pack requested" do
    Pack.should_receive(:find).with("1").and_return(@pack)
    do_update
  end

  specify "should update the found pack" do
    @pack.should_receive(:update_attributes)
    do_update
    assigns(:pack).should equal(@pack)
  end

  specify "should assign the found pack for the view" do
    do_update
    assigns(:pack).should equal(@pack)
  end

  specify "should redirect to the pack" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/packs/1"
  end
end

context "Requesting /packs/1 using DELETE" do
  controller_name :packs

  setup do
    @pack = mock_model(Pack, :destroy => true)
    Pack.stub!(:find).and_return(@pack)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the pack requested" do
    Pack.should_receive(:find).with("1").and_return(@pack)
    do_delete
  end
  
  specify "should call destroy on the found pack" do
    @pack.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the packs list" do
    do_delete
    response.should redirect_to("http://test.host/packs")
  end
end