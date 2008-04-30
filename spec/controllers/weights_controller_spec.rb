require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the WeightsController should map" do
  controller_name :weights

  specify "{ :controller => 'weights', :action => 'index' } to /weights" do
    route_for(:controller => "weights", :action => "index").should == "/weights"
  end
  
  specify "{ :controller => 'weights', :action => 'new' } to /weights/new" do
    route_for(:controller => "weights", :action => "new").should == "/weights/new"
  end
  
  specify "{ :controller => 'weights', :action => 'show', :id => 1 } to /weights/1" do
    route_for(:controller => "weights", :action => "show", :id => 1).should == "/weights/1"
  end
  
  specify "{ :controller => 'weights', :action => 'edit', :id => 1 } to /weights/1;edit" do
    route_for(:controller => "weights", :action => "edit", :id => 1).should == "/weights/1;edit"
  end
  
  specify "{ :controller => 'weights', :action => 'update', :id => 1} to /weights/1" do
    route_for(:controller => "weights", :action => "update", :id => 1).should == "/weights/1"
  end
  
  specify "{ :controller => 'weights', :action => 'destroy', :id => 1} to /weights/1" do
    route_for(:controller => "weights", :action => "destroy", :id => 1).should == "/weights/1"
  end
end

context "Requesting /weights using GET" do
  controller_name :weights

  setup do
    @weight = mock_model(Weight)
    Weight.stub!(:find).and_return(@weight)
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
  
  specify "should find all weights" do
    Weight.should_receive(:find).with(:all).and_return([@weight])
    do_get
  end
  
  specify "should assign the found weights for the view" do
    do_get
    assigns[:weights].should equal(@weight)
  end
end

context "Requesting /weights.xml using GET" do
  controller_name :weights

  setup do
    @weight = mock_model(Weight, :to_xml => "XML")
    Weight.stub!(:find).and_return(@weight)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all weights" do
    Weight.should_receive(:find).with(:all).and_return([@weight])
    do_get
  end
  
  specify "should render the found weights as xml" do
    @weight.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /weights/1 using GET" do
  controller_name :weights

  setup do
    @weight = mock_model(Weight)
    Weight.stub!(:find).and_return(@weight)
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
  
  specify "should find the weight requested" do
    Weight.should_receive(:find).with("1").and_return(@weight)
    do_get
  end
  
  specify "should assign the found weight for the view" do
    do_get
    assigns[:weight].should equal(@weight)
  end
end

context "Requesting /weights/1.xml using GET" do
  controller_name :weights

  setup do
    @weight = mock_model(Weight, :to_xml => "XML")
    Weight.stub!(:find).and_return(@weight)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the weight requested" do
    Weight.should_receive(:find).with("1").and_return(@weight)
    do_get
  end
  
  specify "should render the found weight as xml" do
    @weight.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /weights/new using GET" do
  controller_name :weights

  setup do
    @weight = mock_model(Weight)
    Weight.stub!(:new).and_return(@weight)
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
  
  specify "should create an new weight" do
    Weight.should_receive(:new).and_return(@weight)
    do_get
  end
  
  specify "should not save the new weight" do
    @weight.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new weight for the view" do
    do_get
    assigns[:weight].should be(@weight)
  end
end

context "Requesting /weights/1;edit using GET" do
  controller_name :weights

  setup do
    @weight = mock_model(Weight)
    Weight.stub!(:find).and_return(@weight)
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
  
  specify "should find the weight requested" do
    Weight.should_receive(:find).and_return(@weight)
    do_get
  end
  
  specify "should assign the found Weight for the view" do
    do_get
    assigns[:weight].should equal(@weight)
  end
end

context "Requesting /weights using POST" do
  controller_name :weights

  setup do
    @weight = mock_model(Weight, :to_param => "1", :save => true)
    Weight.stub!(:new).and_return(@weight)
  end
  
  def do_post
    post :create, :weight => {:name => 'Weight'}
  end
  
  specify "should create a new weight" do
    Weight.should_receive(:new).with({'name' => 'Weight'}).and_return(@weight)
    do_post
  end

  specify "should redirect to the new weight" do
    do_post
    response.should redirect_to("http://test.host/weights/1")
  end
end

context "Requesting /weights/1 using PUT" do
  controller_name :weights

  setup do
    @weight = mock_model(Weight, :to_param => "1", :update_attributes => true)
    Weight.stub!(:find).and_return(@weight)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the weight requested" do
    Weight.should_receive(:find).with("1").and_return(@weight)
    do_update
  end

  specify "should update the found weight" do
    @weight.should_receive(:update_attributes)
    do_update
    assigns(:weight).should equal(@weight)
  end

  specify "should assign the found weight for the view" do
    do_update
    assigns(:weight).should equal(@weight)
  end

  specify "should redirect to the weight" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/weights/1"
  end
end

context "Requesting /weights/1 using DELETE" do
  controller_name :weights

  setup do
    @weight = mock_model(Weight, :destroy => true)
    Weight.stub!(:find).and_return(@weight)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the weight requested" do
    Weight.should_receive(:find).with("1").and_return(@weight)
    do_delete
  end
  
  specify "should call destroy on the found weight" do
    @weight.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the weights list" do
    do_delete
    response.should redirect_to("http://test.host/weights")
  end
end