require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the PerCaseOptionsController should map" do
  controller_name :per_case_options

  specify "{ :controller => 'per_case_options', :action => 'index' } to /per_case_options" do
    route_for(:controller => "per_case_options", :action => "index").should == "/per_case_options"
  end
  
  specify "{ :controller => 'per_case_options', :action => 'new' } to /per_case_options/new" do
    route_for(:controller => "per_case_options", :action => "new").should == "/per_case_options/new"
  end
  
  specify "{ :controller => 'per_case_options', :action => 'show', :id => 1 } to /per_case_options/1" do
    route_for(:controller => "per_case_options", :action => "show", :id => 1).should == "/per_case_options/1"
  end
  
  specify "{ :controller => 'per_case_options', :action => 'edit', :id => 1 } to /per_case_options/1;edit" do
    route_for(:controller => "per_case_options", :action => "edit", :id => 1).should == "/per_case_options/1;edit"
  end
  
  specify "{ :controller => 'per_case_options', :action => 'update', :id => 1} to /per_case_options/1" do
    route_for(:controller => "per_case_options", :action => "update", :id => 1).should == "/per_case_options/1"
  end
  
  specify "{ :controller => 'per_case_options', :action => 'destroy', :id => 1} to /per_case_options/1" do
    route_for(:controller => "per_case_options", :action => "destroy", :id => 1).should == "/per_case_options/1"
  end
end

context "Requesting /per_case_options using GET" do
  controller_name :per_case_options

  setup do
    @per_case_option = mock_model(PerCaseOption)
    PerCaseOption.stub!(:find).and_return(@per_case_option)
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
  
  specify "should find all per_case_options" do
    PerCaseOption.should_receive(:find).with(:all).and_return([@per_case_option])
    do_get
  end
  
  specify "should assign the found per_case_options for the view" do
    do_get
    assigns[:per_case_options].should equal(@per_case_option)
  end
end

context "Requesting /per_case_options.xml using GET" do
  controller_name :per_case_options

  setup do
    @per_case_option = mock_model(PerCaseOption, :to_xml => "XML")
    PerCaseOption.stub!(:find).and_return(@per_case_option)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all per_case_options" do
    PerCaseOption.should_receive(:find).with(:all).and_return([@per_case_option])
    do_get
  end
  
  specify "should render the found per_case_options as xml" do
    @per_case_option.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /per_case_options/1 using GET" do
  controller_name :per_case_options

  setup do
    @per_case_option = mock_model(PerCaseOption)
    PerCaseOption.stub!(:find).and_return(@per_case_option)
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
  
  specify "should find the per_case_option requested" do
    PerCaseOption.should_receive(:find).with("1").and_return(@per_case_option)
    do_get
  end
  
  specify "should assign the found per_case_option for the view" do
    do_get
    assigns[:per_case_option].should equal(@per_case_option)
  end
end

context "Requesting /per_case_options/1.xml using GET" do
  controller_name :per_case_options

  setup do
    @per_case_option = mock_model(PerCaseOption, :to_xml => "XML")
    PerCaseOption.stub!(:find).and_return(@per_case_option)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the per_case_option requested" do
    PerCaseOption.should_receive(:find).with("1").and_return(@per_case_option)
    do_get
  end
  
  specify "should render the found per_case_option as xml" do
    @per_case_option.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /per_case_options/new using GET" do
  controller_name :per_case_options

  setup do
    @per_case_option = mock_model(PerCaseOption)
    PerCaseOption.stub!(:new).and_return(@per_case_option)
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
  
  specify "should create an new per_case_option" do
    PerCaseOption.should_receive(:new).and_return(@per_case_option)
    do_get
  end
  
  specify "should not save the new per_case_option" do
    @per_case_option.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new per_case_option for the view" do
    do_get
    assigns[:per_case_option].should be(@per_case_option)
  end
end

context "Requesting /per_case_options/1;edit using GET" do
  controller_name :per_case_options

  setup do
    @per_case_option = mock_model(PerCaseOption)
    PerCaseOption.stub!(:find).and_return(@per_case_option)
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
  
  specify "should find the per_case_option requested" do
    PerCaseOption.should_receive(:find).and_return(@per_case_option)
    do_get
  end
  
  specify "should assign the found PerCaseOption for the view" do
    do_get
    assigns[:per_case_option].should equal(@per_case_option)
  end
end

context "Requesting /per_case_options using POST" do
  controller_name :per_case_options

  setup do
    @per_case_option = mock_model(PerCaseOption, :to_param => "1", :save => true)
    PerCaseOption.stub!(:new).and_return(@per_case_option)
  end
  
  def do_post
    post :create, :per_case_option => {:name => 'PerCaseOption'}
  end
  
  specify "should create a new per_case_option" do
    PerCaseOption.should_receive(:new).with({'name' => 'PerCaseOption'}).and_return(@per_case_option)
    do_post
  end

  specify "should redirect to the new per_case_option" do
    do_post
    response.should redirect_to("http://test.host/per_case_options/1")
  end
end

context "Requesting /per_case_options/1 using PUT" do
  controller_name :per_case_options

  setup do
    @per_case_option = mock_model(PerCaseOption, :to_param => "1", :update_attributes => true)
    PerCaseOption.stub!(:find).and_return(@per_case_option)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the per_case_option requested" do
    PerCaseOption.should_receive(:find).with("1").and_return(@per_case_option)
    do_update
  end

  specify "should update the found per_case_option" do
    @per_case_option.should_receive(:update_attributes)
    do_update
    assigns(:per_case_option).should equal(@per_case_option)
  end

  specify "should assign the found per_case_option for the view" do
    do_update
    assigns(:per_case_option).should equal(@per_case_option)
  end

  specify "should redirect to the per_case_option" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/per_case_options/1"
  end
end

context "Requesting /per_case_options/1 using DELETE" do
  controller_name :per_case_options

  setup do
    @per_case_option = mock_model(PerCaseOption, :destroy => true)
    PerCaseOption.stub!(:find).and_return(@per_case_option)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the per_case_option requested" do
    PerCaseOption.should_receive(:find).with("1").and_return(@per_case_option)
    do_delete
  end
  
  specify "should call destroy on the found per_case_option" do
    @per_case_option.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the per_case_options list" do
    do_delete
    response.should redirect_to("http://test.host/per_case_options")
  end
end