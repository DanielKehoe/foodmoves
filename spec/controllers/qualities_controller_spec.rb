require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the QualitiesController should map" do
  controller_name :qualities

  specify "{ :controller => 'qualities', :action => 'index' } to /qualities" do
    route_for(:controller => "qualities", :action => "index").should == "/qualities"
  end
  
  specify "{ :controller => 'qualities', :action => 'new' } to /qualities/new" do
    route_for(:controller => "qualities", :action => "new").should == "/qualities/new"
  end
  
  specify "{ :controller => 'qualities', :action => 'show', :id => 1 } to /qualities/1" do
    route_for(:controller => "qualities", :action => "show", :id => 1).should == "/qualities/1"
  end
  
  specify "{ :controller => 'qualities', :action => 'edit', :id => 1 } to /qualities/1;edit" do
    route_for(:controller => "qualities", :action => "edit", :id => 1).should == "/qualities/1;edit"
  end
  
  specify "{ :controller => 'qualities', :action => 'update', :id => 1} to /qualities/1" do
    route_for(:controller => "qualities", :action => "update", :id => 1).should == "/qualities/1"
  end
  
  specify "{ :controller => 'qualities', :action => 'destroy', :id => 1} to /qualities/1" do
    route_for(:controller => "qualities", :action => "destroy", :id => 1).should == "/qualities/1"
  end
end

context "Requesting /qualities using GET" do
  controller_name :qualities

  setup do
    @quality = mock_model(Quality)
    Quality.stub!(:find).and_return(@quality)
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
  
  specify "should find all qualities" do
    Quality.should_receive(:find).with(:all).and_return([@quality])
    do_get
  end
  
  specify "should assign the found qualities for the view" do
    do_get
    assigns[:qualities].should equal(@quality)
  end
end

context "Requesting /qualities.xml using GET" do
  controller_name :qualities

  setup do
    @quality = mock_model(Quality, :to_xml => "XML")
    Quality.stub!(:find).and_return(@quality)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all qualities" do
    Quality.should_receive(:find).with(:all).and_return([@quality])
    do_get
  end
  
  specify "should render the found qualities as xml" do
    @quality.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /qualities/1 using GET" do
  controller_name :qualities

  setup do
    @quality = mock_model(Quality)
    Quality.stub!(:find).and_return(@quality)
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
  
  specify "should find the quality requested" do
    Quality.should_receive(:find).with("1").and_return(@quality)
    do_get
  end
  
  specify "should assign the found quality for the view" do
    do_get
    assigns[:quality].should equal(@quality)
  end
end

context "Requesting /qualities/1.xml using GET" do
  controller_name :qualities

  setup do
    @quality = mock_model(Quality, :to_xml => "XML")
    Quality.stub!(:find).and_return(@quality)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the quality requested" do
    Quality.should_receive(:find).with("1").and_return(@quality)
    do_get
  end
  
  specify "should render the found quality as xml" do
    @quality.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /qualities/new using GET" do
  controller_name :qualities

  setup do
    @quality = mock_model(Quality)
    Quality.stub!(:new).and_return(@quality)
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
  
  specify "should create an new quality" do
    Quality.should_receive(:new).and_return(@quality)
    do_get
  end
  
  specify "should not save the new quality" do
    @quality.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new quality for the view" do
    do_get
    assigns[:quality].should be(@quality)
  end
end

context "Requesting /qualities/1;edit using GET" do
  controller_name :qualities

  setup do
    @quality = mock_model(Quality)
    Quality.stub!(:find).and_return(@quality)
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
  
  specify "should find the quality requested" do
    Quality.should_receive(:find).and_return(@quality)
    do_get
  end
  
  specify "should assign the found Quality for the view" do
    do_get
    assigns[:quality].should equal(@quality)
  end
end

context "Requesting /qualities using POST" do
  controller_name :qualities

  setup do
    @quality = mock_model(Quality, :to_param => "1", :save => true)
    Quality.stub!(:new).and_return(@quality)
  end
  
  def do_post
    post :create, :quality => {:name => 'Quality'}
  end
  
  specify "should create a new quality" do
    Quality.should_receive(:new).with({'name' => 'Quality'}).and_return(@quality)
    do_post
  end

  specify "should redirect to the new quality" do
    do_post
    response.should redirect_to("http://test.host/qualities/1")
  end
end

context "Requesting /qualities/1 using PUT" do
  controller_name :qualities

  setup do
    @quality = mock_model(Quality, :to_param => "1", :update_attributes => true)
    Quality.stub!(:find).and_return(@quality)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the quality requested" do
    Quality.should_receive(:find).with("1").and_return(@quality)
    do_update
  end

  specify "should update the found quality" do
    @quality.should_receive(:update_attributes)
    do_update
    assigns(:quality).should equal(@quality)
  end

  specify "should assign the found quality for the view" do
    do_update
    assigns(:quality).should equal(@quality)
  end

  specify "should redirect to the quality" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/qualities/1"
  end
end

context "Requesting /qualities/1 using DELETE" do
  controller_name :qualities

  setup do
    @quality = mock_model(Quality, :destroy => true)
    Quality.stub!(:find).and_return(@quality)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the quality requested" do
    Quality.should_receive(:find).with("1").and_return(@quality)
    do_delete
  end
  
  specify "should call destroy on the found quality" do
    @quality.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the qualities list" do
    do_delete
    response.should redirect_to("http://test.host/qualities")
  end
end