require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the PackOptionsController should map" do
  controller_name :pack_options

  specify "{ :controller => 'pack_options', :action => 'index' } to /pack_options" do
    route_for(:controller => "pack_options", :action => "index").should == "/pack_options"
  end
  
  specify "{ :controller => 'pack_options', :action => 'new' } to /pack_options/new" do
    route_for(:controller => "pack_options", :action => "new").should == "/pack_options/new"
  end
  
  specify "{ :controller => 'pack_options', :action => 'show', :id => 1 } to /pack_options/1" do
    route_for(:controller => "pack_options", :action => "show", :id => 1).should == "/pack_options/1"
  end
  
  specify "{ :controller => 'pack_options', :action => 'edit', :id => 1 } to /pack_options/1;edit" do
    route_for(:controller => "pack_options", :action => "edit", :id => 1).should == "/pack_options/1;edit"
  end
  
  specify "{ :controller => 'pack_options', :action => 'update', :id => 1} to /pack_options/1" do
    route_for(:controller => "pack_options", :action => "update", :id => 1).should == "/pack_options/1"
  end
  
  specify "{ :controller => 'pack_options', :action => 'destroy', :id => 1} to /pack_options/1" do
    route_for(:controller => "pack_options", :action => "destroy", :id => 1).should == "/pack_options/1"
  end
end

context "Requesting /pack_options using GET" do
  controller_name :pack_options

  setup do
    @pack_option = mock_model(PackOption)
    PackOption.stub!(:find).and_return(@pack_option)
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
  
  specify "should find all pack_options" do
    PackOption.should_receive(:find).with(:all).and_return([@pack_option])
    do_get
  end
  
  specify "should assign the found pack_options for the view" do
    do_get
    assigns[:pack_options].should equal(@pack_option)
  end
end

context "Requesting /pack_options.xml using GET" do
  controller_name :pack_options

  setup do
    @pack_option = mock_model(PackOption, :to_xml => "XML")
    PackOption.stub!(:find).and_return(@pack_option)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all pack_options" do
    PackOption.should_receive(:find).with(:all).and_return([@pack_option])
    do_get
  end
  
  specify "should render the found pack_options as xml" do
    @pack_option.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /pack_options/1 using GET" do
  controller_name :pack_options

  setup do
    @pack_option = mock_model(PackOption)
    PackOption.stub!(:find).and_return(@pack_option)
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
  
  specify "should find the pack_option requested" do
    PackOption.should_receive(:find).with("1").and_return(@pack_option)
    do_get
  end
  
  specify "should assign the found pack_option for the view" do
    do_get
    assigns[:pack_option].should equal(@pack_option)
  end
end

context "Requesting /pack_options/1.xml using GET" do
  controller_name :pack_options

  setup do
    @pack_option = mock_model(PackOption, :to_xml => "XML")
    PackOption.stub!(:find).and_return(@pack_option)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the pack_option requested" do
    PackOption.should_receive(:find).with("1").and_return(@pack_option)
    do_get
  end
  
  specify "should render the found pack_option as xml" do
    @pack_option.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /pack_options/new using GET" do
  controller_name :pack_options

  setup do
    @pack_option = mock_model(PackOption)
    PackOption.stub!(:new).and_return(@pack_option)
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
  
  specify "should create an new pack_option" do
    PackOption.should_receive(:new).and_return(@pack_option)
    do_get
  end
  
  specify "should not save the new pack_option" do
    @pack_option.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new pack_option for the view" do
    do_get
    assigns[:pack_option].should be(@pack_option)
  end
end

context "Requesting /pack_options/1;edit using GET" do
  controller_name :pack_options

  setup do
    @pack_option = mock_model(PackOption)
    PackOption.stub!(:find).and_return(@pack_option)
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
  
  specify "should find the pack_option requested" do
    PackOption.should_receive(:find).and_return(@pack_option)
    do_get
  end
  
  specify "should assign the found PackOption for the view" do
    do_get
    assigns[:pack_option].should equal(@pack_option)
  end
end

context "Requesting /pack_options using POST" do
  controller_name :pack_options

  setup do
    @pack_option = mock_model(PackOption, :to_param => "1", :save => true)
    PackOption.stub!(:new).and_return(@pack_option)
  end
  
  def do_post
    post :create, :pack_option => {:name => 'PackOption'}
  end
  
  specify "should create a new pack_option" do
    PackOption.should_receive(:new).with({'name' => 'PackOption'}).and_return(@pack_option)
    do_post
  end

  specify "should redirect to the new pack_option" do
    do_post
    response.should redirect_to("http://test.host/pack_options/1")
  end
end

context "Requesting /pack_options/1 using PUT" do
  controller_name :pack_options

  setup do
    @pack_option = mock_model(PackOption, :to_param => "1", :update_attributes => true)
    PackOption.stub!(:find).and_return(@pack_option)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the pack_option requested" do
    PackOption.should_receive(:find).with("1").and_return(@pack_option)
    do_update
  end

  specify "should update the found pack_option" do
    @pack_option.should_receive(:update_attributes)
    do_update
    assigns(:pack_option).should equal(@pack_option)
  end

  specify "should assign the found pack_option for the view" do
    do_update
    assigns(:pack_option).should equal(@pack_option)
  end

  specify "should redirect to the pack_option" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/pack_options/1"
  end
end

context "Requesting /pack_options/1 using DELETE" do
  controller_name :pack_options

  setup do
    @pack_option = mock_model(PackOption, :destroy => true)
    PackOption.stub!(:find).and_return(@pack_option)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the pack_option requested" do
    PackOption.should_receive(:find).with("1").and_return(@pack_option)
    do_delete
  end
  
  specify "should call destroy on the found pack_option" do
    @pack_option.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the pack_options list" do
    do_delete
    response.should redirect_to("http://test.host/pack_options")
  end
end