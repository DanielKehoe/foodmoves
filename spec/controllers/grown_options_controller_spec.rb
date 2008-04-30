require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the GrownOptionsController should map" do
  controller_name :grown_options

  specify "{ :controller => 'grown_options', :action => 'index' } to /grown_options" do
    route_for(:controller => "grown_options", :action => "index").should == "/grown_options"
  end
  
  specify "{ :controller => 'grown_options', :action => 'new' } to /grown_options/new" do
    route_for(:controller => "grown_options", :action => "new").should == "/grown_options/new"
  end
  
  specify "{ :controller => 'grown_options', :action => 'show', :id => 1 } to /grown_options/1" do
    route_for(:controller => "grown_options", :action => "show", :id => 1).should == "/grown_options/1"
  end
  
  specify "{ :controller => 'grown_options', :action => 'edit', :id => 1 } to /grown_options/1;edit" do
    route_for(:controller => "grown_options", :action => "edit", :id => 1).should == "/grown_options/1;edit"
  end
  
  specify "{ :controller => 'grown_options', :action => 'update', :id => 1} to /grown_options/1" do
    route_for(:controller => "grown_options", :action => "update", :id => 1).should == "/grown_options/1"
  end
  
  specify "{ :controller => 'grown_options', :action => 'destroy', :id => 1} to /grown_options/1" do
    route_for(:controller => "grown_options", :action => "destroy", :id => 1).should == "/grown_options/1"
  end
end

context "Requesting /grown_options using GET" do
  controller_name :grown_options

  setup do
    @grown_option = mock_model(GrownOption)
    GrownOption.stub!(:find).and_return(@grown_option)
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
  
  specify "should find all grown_options" do
    GrownOption.should_receive(:find).with(:all).and_return([@grown_option])
    do_get
  end
  
  specify "should assign the found grown_options for the view" do
    do_get
    assigns[:grown_options].should equal(@grown_option)
  end
end

context "Requesting /grown_options.xml using GET" do
  controller_name :grown_options

  setup do
    @grown_option = mock_model(GrownOption, :to_xml => "XML")
    GrownOption.stub!(:find).and_return(@grown_option)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all grown_options" do
    GrownOption.should_receive(:find).with(:all).and_return([@grown_option])
    do_get
  end
  
  specify "should render the found grown_options as xml" do
    @grown_option.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /grown_options/1 using GET" do
  controller_name :grown_options

  setup do
    @grown_option = mock_model(GrownOption)
    GrownOption.stub!(:find).and_return(@grown_option)
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
  
  specify "should find the grown_option requested" do
    GrownOption.should_receive(:find).with("1").and_return(@grown_option)
    do_get
  end
  
  specify "should assign the found grown_option for the view" do
    do_get
    assigns[:grown_option].should equal(@grown_option)
  end
end

context "Requesting /grown_options/1.xml using GET" do
  controller_name :grown_options

  setup do
    @grown_option = mock_model(GrownOption, :to_xml => "XML")
    GrownOption.stub!(:find).and_return(@grown_option)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the grown_option requested" do
    GrownOption.should_receive(:find).with("1").and_return(@grown_option)
    do_get
  end
  
  specify "should render the found grown_option as xml" do
    @grown_option.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /grown_options/new using GET" do
  controller_name :grown_options

  setup do
    @grown_option = mock_model(GrownOption)
    GrownOption.stub!(:new).and_return(@grown_option)
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
  
  specify "should create an new grown_option" do
    GrownOption.should_receive(:new).and_return(@grown_option)
    do_get
  end
  
  specify "should not save the new grown_option" do
    @grown_option.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new grown_option for the view" do
    do_get
    assigns[:grown_option].should be(@grown_option)
  end
end

context "Requesting /grown_options/1;edit using GET" do
  controller_name :grown_options

  setup do
    @grown_option = mock_model(GrownOption)
    GrownOption.stub!(:find).and_return(@grown_option)
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
  
  specify "should find the grown_option requested" do
    GrownOption.should_receive(:find).and_return(@grown_option)
    do_get
  end
  
  specify "should assign the found GrownOption for the view" do
    do_get
    assigns[:grown_option].should equal(@grown_option)
  end
end

context "Requesting /grown_options using POST" do
  controller_name :grown_options

  setup do
    @grown_option = mock_model(GrownOption, :to_param => "1", :save => true)
    GrownOption.stub!(:new).and_return(@grown_option)
  end
  
  def do_post
    post :create, :grown_option => {:name => 'GrownOption'}
  end
  
  specify "should create a new grown_option" do
    GrownOption.should_receive(:new).with({'name' => 'GrownOption'}).and_return(@grown_option)
    do_post
  end

  specify "should redirect to the new grown_option" do
    do_post
    response.should redirect_to("http://test.host/grown_options/1")
  end
end

context "Requesting /grown_options/1 using PUT" do
  controller_name :grown_options

  setup do
    @grown_option = mock_model(GrownOption, :to_param => "1", :update_attributes => true)
    GrownOption.stub!(:find).and_return(@grown_option)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the grown_option requested" do
    GrownOption.should_receive(:find).with("1").and_return(@grown_option)
    do_update
  end

  specify "should update the found grown_option" do
    @grown_option.should_receive(:update_attributes)
    do_update
    assigns(:grown_option).should equal(@grown_option)
  end

  specify "should assign the found grown_option for the view" do
    do_update
    assigns(:grown_option).should equal(@grown_option)
  end

  specify "should redirect to the grown_option" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/grown_options/1"
  end
end

context "Requesting /grown_options/1 using DELETE" do
  controller_name :grown_options

  setup do
    @grown_option = mock_model(GrownOption, :destroy => true)
    GrownOption.stub!(:find).and_return(@grown_option)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the grown_option requested" do
    GrownOption.should_receive(:find).with("1").and_return(@grown_option)
    do_delete
  end
  
  specify "should call destroy on the found grown_option" do
    @grown_option.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the grown_options list" do
    do_delete
    response.should redirect_to("http://test.host/grown_options")
  end
end