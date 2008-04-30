require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the ColorOptionsController should map" do
  controller_name :color_options

  specify "{ :controller => 'color_options', :action => 'index' } to /color_options" do
    route_for(:controller => "color_options", :action => "index").should == "/color_options"
  end
  
  specify "{ :controller => 'color_options', :action => 'new' } to /color_options/new" do
    route_for(:controller => "color_options", :action => "new").should == "/color_options/new"
  end
  
  specify "{ :controller => 'color_options', :action => 'show', :id => 1 } to /color_options/1" do
    route_for(:controller => "color_options", :action => "show", :id => 1).should == "/color_options/1"
  end
  
  specify "{ :controller => 'color_options', :action => 'edit', :id => 1 } to /color_options/1;edit" do
    route_for(:controller => "color_options", :action => "edit", :id => 1).should == "/color_options/1;edit"
  end
  
  specify "{ :controller => 'color_options', :action => 'update', :id => 1} to /color_options/1" do
    route_for(:controller => "color_options", :action => "update", :id => 1).should == "/color_options/1"
  end
  
  specify "{ :controller => 'color_options', :action => 'destroy', :id => 1} to /color_options/1" do
    route_for(:controller => "color_options", :action => "destroy", :id => 1).should == "/color_options/1"
  end
end

context "Requesting /color_options using GET" do
  controller_name :color_options

  setup do
    @color_option = mock_model(ColorOption)
    ColorOption.stub!(:find).and_return(@color_option)
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
  
  specify "should find all color_options" do
    ColorOption.should_receive(:find).with(:all).and_return([@color_option])
    do_get
  end
  
  specify "should assign the found color_options for the view" do
    do_get
    assigns[:color_options].should equal(@color_option)
  end
end

context "Requesting /color_options.xml using GET" do
  controller_name :color_options

  setup do
    @color_option = mock_model(ColorOption, :to_xml => "XML")
    ColorOption.stub!(:find).and_return(@color_option)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all color_options" do
    ColorOption.should_receive(:find).with(:all).and_return([@color_option])
    do_get
  end
  
  specify "should render the found color_options as xml" do
    @color_option.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /color_options/1 using GET" do
  controller_name :color_options

  setup do
    @color_option = mock_model(ColorOption)
    ColorOption.stub!(:find).and_return(@color_option)
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
  
  specify "should find the color_option requested" do
    ColorOption.should_receive(:find).with("1").and_return(@color_option)
    do_get
  end
  
  specify "should assign the found color_option for the view" do
    do_get
    assigns[:color_option].should equal(@color_option)
  end
end

context "Requesting /color_options/1.xml using GET" do
  controller_name :color_options

  setup do
    @color_option = mock_model(ColorOption, :to_xml => "XML")
    ColorOption.stub!(:find).and_return(@color_option)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the color_option requested" do
    ColorOption.should_receive(:find).with("1").and_return(@color_option)
    do_get
  end
  
  specify "should render the found color_option as xml" do
    @color_option.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /color_options/new using GET" do
  controller_name :color_options

  setup do
    @color_option = mock_model(ColorOption)
    ColorOption.stub!(:new).and_return(@color_option)
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
  
  specify "should create an new color_option" do
    ColorOption.should_receive(:new).and_return(@color_option)
    do_get
  end
  
  specify "should not save the new color_option" do
    @color_option.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new color_option for the view" do
    do_get
    assigns[:color_option].should be(@color_option)
  end
end

context "Requesting /color_options/1;edit using GET" do
  controller_name :color_options

  setup do
    @color_option = mock_model(ColorOption)
    ColorOption.stub!(:find).and_return(@color_option)
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
  
  specify "should find the color_option requested" do
    ColorOption.should_receive(:find).and_return(@color_option)
    do_get
  end
  
  specify "should assign the found ColorOption for the view" do
    do_get
    assigns[:color_option].should equal(@color_option)
  end
end

context "Requesting /color_options using POST" do
  controller_name :color_options

  setup do
    @color_option = mock_model(ColorOption, :to_param => "1", :save => true)
    ColorOption.stub!(:new).and_return(@color_option)
  end
  
  def do_post
    post :create, :color_option => {:name => 'ColorOption'}
  end
  
  specify "should create a new color_option" do
    ColorOption.should_receive(:new).with({'name' => 'ColorOption'}).and_return(@color_option)
    do_post
  end

  specify "should redirect to the new color_option" do
    do_post
    response.should redirect_to("http://test.host/color_options/1")
  end
end

context "Requesting /color_options/1 using PUT" do
  controller_name :color_options

  setup do
    @color_option = mock_model(ColorOption, :to_param => "1", :update_attributes => true)
    ColorOption.stub!(:find).and_return(@color_option)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the color_option requested" do
    ColorOption.should_receive(:find).with("1").and_return(@color_option)
    do_update
  end

  specify "should update the found color_option" do
    @color_option.should_receive(:update_attributes)
    do_update
    assigns(:color_option).should equal(@color_option)
  end

  specify "should assign the found color_option for the view" do
    do_update
    assigns(:color_option).should equal(@color_option)
  end

  specify "should redirect to the color_option" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/color_options/1"
  end
end

context "Requesting /color_options/1 using DELETE" do
  controller_name :color_options

  setup do
    @color_option = mock_model(ColorOption, :destroy => true)
    ColorOption.stub!(:find).and_return(@color_option)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the color_option requested" do
    ColorOption.should_receive(:find).with("1").and_return(@color_option)
    do_delete
  end
  
  specify "should call destroy on the found color_option" do
    @color_option.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the color_options list" do
    do_delete
    response.should redirect_to("http://test.host/color_options")
  end
end