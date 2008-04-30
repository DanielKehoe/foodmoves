require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the SizeOptionsController should map" do
  controller_name :size_options

  specify "{ :controller => 'size_options', :action => 'index' } to /size_options" do
    route_for(:controller => "size_options", :action => "index").should == "/size_options"
  end
  
  specify "{ :controller => 'size_options', :action => 'new' } to /size_options/new" do
    route_for(:controller => "size_options", :action => "new").should == "/size_options/new"
  end
  
  specify "{ :controller => 'size_options', :action => 'show', :id => 1 } to /size_options/1" do
    route_for(:controller => "size_options", :action => "show", :id => 1).should == "/size_options/1"
  end
  
  specify "{ :controller => 'size_options', :action => 'edit', :id => 1 } to /size_options/1;edit" do
    route_for(:controller => "size_options", :action => "edit", :id => 1).should == "/size_options/1;edit"
  end
  
  specify "{ :controller => 'size_options', :action => 'update', :id => 1} to /size_options/1" do
    route_for(:controller => "size_options", :action => "update", :id => 1).should == "/size_options/1"
  end
  
  specify "{ :controller => 'size_options', :action => 'destroy', :id => 1} to /size_options/1" do
    route_for(:controller => "size_options", :action => "destroy", :id => 1).should == "/size_options/1"
  end
end

context "Requesting /size_options using GET" do
  controller_name :size_options

  setup do
    @size_option = mock_model(SizeOption)
    SizeOption.stub!(:find).and_return(@size_option)
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
  
  specify "should find all size_options" do
    SizeOption.should_receive(:find).with(:all).and_return([@size_option])
    do_get
  end
  
  specify "should assign the found size_options for the view" do
    do_get
    assigns[:size_options].should equal(@size_option)
  end
end

context "Requesting /size_options.xml using GET" do
  controller_name :size_options

  setup do
    @size_option = mock_model(SizeOption, :to_xml => "XML")
    SizeOption.stub!(:find).and_return(@size_option)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all size_options" do
    SizeOption.should_receive(:find).with(:all).and_return([@size_option])
    do_get
  end
  
  specify "should render the found size_options as xml" do
    @size_option.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /size_options/1 using GET" do
  controller_name :size_options

  setup do
    @size_option = mock_model(SizeOption)
    SizeOption.stub!(:find).and_return(@size_option)
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
  
  specify "should find the size_option requested" do
    SizeOption.should_receive(:find).with("1").and_return(@size_option)
    do_get
  end
  
  specify "should assign the found size_option for the view" do
    do_get
    assigns[:size_option].should equal(@size_option)
  end
end

context "Requesting /size_options/1.xml using GET" do
  controller_name :size_options

  setup do
    @size_option = mock_model(SizeOption, :to_xml => "XML")
    SizeOption.stub!(:find).and_return(@size_option)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the size_option requested" do
    SizeOption.should_receive(:find).with("1").and_return(@size_option)
    do_get
  end
  
  specify "should render the found size_option as xml" do
    @size_option.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /size_options/new using GET" do
  controller_name :size_options

  setup do
    @size_option = mock_model(SizeOption)
    SizeOption.stub!(:new).and_return(@size_option)
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
  
  specify "should create an new size_option" do
    SizeOption.should_receive(:new).and_return(@size_option)
    do_get
  end
  
  specify "should not save the new size_option" do
    @size_option.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new size_option for the view" do
    do_get
    assigns[:size_option].should be(@size_option)
  end
end

context "Requesting /size_options/1;edit using GET" do
  controller_name :size_options

  setup do
    @size_option = mock_model(SizeOption)
    SizeOption.stub!(:find).and_return(@size_option)
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
  
  specify "should find the size_option requested" do
    SizeOption.should_receive(:find).and_return(@size_option)
    do_get
  end
  
  specify "should assign the found SizeOption for the view" do
    do_get
    assigns[:size_option].should equal(@size_option)
  end
end

context "Requesting /size_options using POST" do
  controller_name :size_options

  setup do
    @size_option = mock_model(SizeOption, :to_param => "1", :save => true)
    SizeOption.stub!(:new).and_return(@size_option)
  end
  
  def do_post
    post :create, :size_option => {:name => 'SizeOption'}
  end
  
  specify "should create a new size_option" do
    SizeOption.should_receive(:new).with({'name' => 'SizeOption'}).and_return(@size_option)
    do_post
  end

  specify "should redirect to the new size_option" do
    do_post
    response.should redirect_to("http://test.host/size_options/1")
  end
end

context "Requesting /size_options/1 using PUT" do
  controller_name :size_options

  setup do
    @size_option = mock_model(SizeOption, :to_param => "1", :update_attributes => true)
    SizeOption.stub!(:find).and_return(@size_option)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the size_option requested" do
    SizeOption.should_receive(:find).with("1").and_return(@size_option)
    do_update
  end

  specify "should update the found size_option" do
    @size_option.should_receive(:update_attributes)
    do_update
    assigns(:size_option).should equal(@size_option)
  end

  specify "should assign the found size_option for the view" do
    do_update
    assigns(:size_option).should equal(@size_option)
  end

  specify "should redirect to the size_option" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/size_options/1"
  end
end

context "Requesting /size_options/1 using DELETE" do
  controller_name :size_options

  setup do
    @size_option = mock_model(SizeOption, :destroy => true)
    SizeOption.stub!(:find).and_return(@size_option)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the size_option requested" do
    SizeOption.should_receive(:find).with("1").and_return(@size_option)
    do_delete
  end
  
  specify "should call destroy on the found size_option" do
    @size_option.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the size_options list" do
    do_delete
    response.should redirect_to("http://test.host/size_options")
  end
end