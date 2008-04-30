require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the SizesController should map" do
  controller_name :sizes

  specify "{ :controller => 'sizes', :action => 'index' } to /sizes" do
    route_for(:controller => "sizes", :action => "index").should == "/sizes"
  end
  
  specify "{ :controller => 'sizes', :action => 'new' } to /sizes/new" do
    route_for(:controller => "sizes", :action => "new").should == "/sizes/new"
  end
  
  specify "{ :controller => 'sizes', :action => 'show', :id => 1 } to /sizes/1" do
    route_for(:controller => "sizes", :action => "show", :id => 1).should == "/sizes/1"
  end
  
  specify "{ :controller => 'sizes', :action => 'edit', :id => 1 } to /sizes/1;edit" do
    route_for(:controller => "sizes", :action => "edit", :id => 1).should == "/sizes/1;edit"
  end
  
  specify "{ :controller => 'sizes', :action => 'update', :id => 1} to /sizes/1" do
    route_for(:controller => "sizes", :action => "update", :id => 1).should == "/sizes/1"
  end
  
  specify "{ :controller => 'sizes', :action => 'destroy', :id => 1} to /sizes/1" do
    route_for(:controller => "sizes", :action => "destroy", :id => 1).should == "/sizes/1"
  end
end

context "Requesting /sizes using GET" do
  controller_name :sizes

  setup do
    @size = mock_model(Size)
    Size.stub!(:find).and_return(@size)
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
  
  specify "should find all sizes" do
    Size.should_receive(:find).with(:all).and_return([@size])
    do_get
  end
  
  specify "should assign the found sizes for the view" do
    do_get
    assigns[:sizes].should equal(@size)
  end
end

context "Requesting /sizes.xml using GET" do
  controller_name :sizes

  setup do
    @size = mock_model(Size, :to_xml => "XML")
    Size.stub!(:find).and_return(@size)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all sizes" do
    Size.should_receive(:find).with(:all).and_return([@size])
    do_get
  end
  
  specify "should render the found sizes as xml" do
    @size.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /sizes/1 using GET" do
  controller_name :sizes

  setup do
    @size = mock_model(Size)
    Size.stub!(:find).and_return(@size)
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
  
  specify "should find the size requested" do
    Size.should_receive(:find).with("1").and_return(@size)
    do_get
  end
  
  specify "should assign the found size for the view" do
    do_get
    assigns[:size].should equal(@size)
  end
end

context "Requesting /sizes/1.xml using GET" do
  controller_name :sizes

  setup do
    @size = mock_model(Size, :to_xml => "XML")
    Size.stub!(:find).and_return(@size)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the size requested" do
    Size.should_receive(:find).with("1").and_return(@size)
    do_get
  end
  
  specify "should render the found size as xml" do
    @size.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /sizes/new using GET" do
  controller_name :sizes

  setup do
    @size = mock_model(Size)
    Size.stub!(:new).and_return(@size)
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
  
  specify "should create an new size" do
    Size.should_receive(:new).and_return(@size)
    do_get
  end
  
  specify "should not save the new size" do
    @size.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new size for the view" do
    do_get
    assigns[:size].should be(@size)
  end
end

context "Requesting /sizes/1;edit using GET" do
  controller_name :sizes

  setup do
    @size = mock_model(Size)
    Size.stub!(:find).and_return(@size)
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
  
  specify "should find the size requested" do
    Size.should_receive(:find).and_return(@size)
    do_get
  end
  
  specify "should assign the found Size for the view" do
    do_get
    assigns[:size].should equal(@size)
  end
end

context "Requesting /sizes using POST" do
  controller_name :sizes

  setup do
    @size = mock_model(Size, :to_param => "1", :save => true)
    Size.stub!(:new).and_return(@size)
  end
  
  def do_post
    post :create, :size => {:name => 'Size'}
  end
  
  specify "should create a new size" do
    Size.should_receive(:new).with({'name' => 'Size'}).and_return(@size)
    do_post
  end

  specify "should redirect to the new size" do
    do_post
    response.should redirect_to("http://test.host/sizes/1")
  end
end

context "Requesting /sizes/1 using PUT" do
  controller_name :sizes

  setup do
    @size = mock_model(Size, :to_param => "1", :update_attributes => true)
    Size.stub!(:find).and_return(@size)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the size requested" do
    Size.should_receive(:find).with("1").and_return(@size)
    do_update
  end

  specify "should update the found size" do
    @size.should_receive(:update_attributes)
    do_update
    assigns(:size).should equal(@size)
  end

  specify "should assign the found size for the view" do
    do_update
    assigns(:size).should equal(@size)
  end

  specify "should redirect to the size" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/sizes/1"
  end
end

context "Requesting /sizes/1 using DELETE" do
  controller_name :sizes

  setup do
    @size = mock_model(Size, :destroy => true)
    Size.stub!(:find).and_return(@size)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the size requested" do
    Size.should_receive(:find).with("1").and_return(@size)
    do_delete
  end
  
  specify "should call destroy on the found size" do
    @size.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the sizes list" do
    do_delete
    response.should redirect_to("http://test.host/sizes")
  end
end