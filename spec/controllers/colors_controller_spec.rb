require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the ColorsController should map" do
  controller_name :colors

  specify "{ :controller => 'colors', :action => 'index' } to /colors" do
    route_for(:controller => "colors", :action => "index").should == "/colors"
  end
  
  specify "{ :controller => 'colors', :action => 'new' } to /colors/new" do
    route_for(:controller => "colors", :action => "new").should == "/colors/new"
  end
  
  specify "{ :controller => 'colors', :action => 'show', :id => 1 } to /colors/1" do
    route_for(:controller => "colors", :action => "show", :id => 1).should == "/colors/1"
  end
  
  specify "{ :controller => 'colors', :action => 'edit', :id => 1 } to /colors/1;edit" do
    route_for(:controller => "colors", :action => "edit", :id => 1).should == "/colors/1;edit"
  end
  
  specify "{ :controller => 'colors', :action => 'update', :id => 1} to /colors/1" do
    route_for(:controller => "colors", :action => "update", :id => 1).should == "/colors/1"
  end
  
  specify "{ :controller => 'colors', :action => 'destroy', :id => 1} to /colors/1" do
    route_for(:controller => "colors", :action => "destroy", :id => 1).should == "/colors/1"
  end
end

context "Requesting /colors using GET" do
  controller_name :colors

  setup do
    @color = mock_model(Color)
    Color.stub!(:find).and_return(@color)
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
  
  specify "should find all colors" do
    Color.should_receive(:find).with(:all).and_return([@color])
    do_get
  end
  
  specify "should assign the found colors for the view" do
    do_get
    assigns[:colors].should equal(@color)
  end
end

context "Requesting /colors.xml using GET" do
  controller_name :colors

  setup do
    @color = mock_model(Color, :to_xml => "XML")
    Color.stub!(:find).and_return(@color)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all colors" do
    Color.should_receive(:find).with(:all).and_return([@color])
    do_get
  end
  
  specify "should render the found colors as xml" do
    @color.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /colors/1 using GET" do
  controller_name :colors

  setup do
    @color = mock_model(Color)
    Color.stub!(:find).and_return(@color)
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
  
  specify "should find the color requested" do
    Color.should_receive(:find).with("1").and_return(@color)
    do_get
  end
  
  specify "should assign the found color for the view" do
    do_get
    assigns[:color].should equal(@color)
  end
end

context "Requesting /colors/1.xml using GET" do
  controller_name :colors

  setup do
    @color = mock_model(Color, :to_xml => "XML")
    Color.stub!(:find).and_return(@color)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the color requested" do
    Color.should_receive(:find).with("1").and_return(@color)
    do_get
  end
  
  specify "should render the found color as xml" do
    @color.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /colors/new using GET" do
  controller_name :colors

  setup do
    @color = mock_model(Color)
    Color.stub!(:new).and_return(@color)
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
  
  specify "should create an new color" do
    Color.should_receive(:new).and_return(@color)
    do_get
  end
  
  specify "should not save the new color" do
    @color.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new color for the view" do
    do_get
    assigns[:color].should be(@color)
  end
end

context "Requesting /colors/1;edit using GET" do
  controller_name :colors

  setup do
    @color = mock_model(Color)
    Color.stub!(:find).and_return(@color)
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
  
  specify "should find the color requested" do
    Color.should_receive(:find).and_return(@color)
    do_get
  end
  
  specify "should assign the found Color for the view" do
    do_get
    assigns[:color].should equal(@color)
  end
end

context "Requesting /colors using POST" do
  controller_name :colors

  setup do
    @color = mock_model(Color, :to_param => "1", :save => true)
    Color.stub!(:new).and_return(@color)
  end
  
  def do_post
    post :create, :color => {:name => 'Color'}
  end
  
  specify "should create a new color" do
    Color.should_receive(:new).with({'name' => 'Color'}).and_return(@color)
    do_post
  end

  specify "should redirect to the new color" do
    do_post
    response.should redirect_to("http://test.host/colors/1")
  end
end

context "Requesting /colors/1 using PUT" do
  controller_name :colors

  setup do
    @color = mock_model(Color, :to_param => "1", :update_attributes => true)
    Color.stub!(:find).and_return(@color)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the color requested" do
    Color.should_receive(:find).with("1").and_return(@color)
    do_update
  end

  specify "should update the found color" do
    @color.should_receive(:update_attributes)
    do_update
    assigns(:color).should equal(@color)
  end

  specify "should assign the found color for the view" do
    do_update
    assigns(:color).should equal(@color)
  end

  specify "should redirect to the color" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/colors/1"
  end
end

context "Requesting /colors/1 using DELETE" do
  controller_name :colors

  setup do
    @color = mock_model(Color, :destroy => true)
    Color.stub!(:find).and_return(@color)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the color requested" do
    Color.should_receive(:find).with("1").and_return(@color)
    do_delete
  end
  
  specify "should call destroy on the found color" do
    @color.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the colors list" do
    do_delete
    response.should redirect_to("http://test.host/colors")
  end
end