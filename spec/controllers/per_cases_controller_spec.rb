require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the PerCasesController should map" do
  controller_name :per_cases

  specify "{ :controller => 'per_cases', :action => 'index' } to /per_cases" do
    route_for(:controller => "per_cases", :action => "index").should == "/per_cases"
  end
  
  specify "{ :controller => 'per_cases', :action => 'new' } to /per_cases/new" do
    route_for(:controller => "per_cases", :action => "new").should == "/per_cases/new"
  end
  
  specify "{ :controller => 'per_cases', :action => 'show', :id => 1 } to /per_cases/1" do
    route_for(:controller => "per_cases", :action => "show", :id => 1).should == "/per_cases/1"
  end
  
  specify "{ :controller => 'per_cases', :action => 'edit', :id => 1 } to /per_cases/1;edit" do
    route_for(:controller => "per_cases", :action => "edit", :id => 1).should == "/per_cases/1;edit"
  end
  
  specify "{ :controller => 'per_cases', :action => 'update', :id => 1} to /per_cases/1" do
    route_for(:controller => "per_cases", :action => "update", :id => 1).should == "/per_cases/1"
  end
  
  specify "{ :controller => 'per_cases', :action => 'destroy', :id => 1} to /per_cases/1" do
    route_for(:controller => "per_cases", :action => "destroy", :id => 1).should == "/per_cases/1"
  end
end

context "Requesting /per_cases using GET" do
  controller_name :per_cases

  setup do
    @per_case = mock_model(PerCase)
    PerCase.stub!(:find).and_return(@per_case)
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
  
  specify "should find all per_cases" do
    PerCase.should_receive(:find).with(:all).and_return([@per_case])
    do_get
  end
  
  specify "should assign the found per_cases for the view" do
    do_get
    assigns[:per_cases].should equal(@per_case)
  end
end

context "Requesting /per_cases.xml using GET" do
  controller_name :per_cases

  setup do
    @per_case = mock_model(PerCase, :to_xml => "XML")
    PerCase.stub!(:find).and_return(@per_case)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all per_cases" do
    PerCase.should_receive(:find).with(:all).and_return([@per_case])
    do_get
  end
  
  specify "should render the found per_cases as xml" do
    @per_case.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /per_cases/1 using GET" do
  controller_name :per_cases

  setup do
    @per_case = mock_model(PerCase)
    PerCase.stub!(:find).and_return(@per_case)
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
  
  specify "should find the per_case requested" do
    PerCase.should_receive(:find).with("1").and_return(@per_case)
    do_get
  end
  
  specify "should assign the found per_case for the view" do
    do_get
    assigns[:per_case].should equal(@per_case)
  end
end

context "Requesting /per_cases/1.xml using GET" do
  controller_name :per_cases

  setup do
    @per_case = mock_model(PerCase, :to_xml => "XML")
    PerCase.stub!(:find).and_return(@per_case)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the per_case requested" do
    PerCase.should_receive(:find).with("1").and_return(@per_case)
    do_get
  end
  
  specify "should render the found per_case as xml" do
    @per_case.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /per_cases/new using GET" do
  controller_name :per_cases

  setup do
    @per_case = mock_model(PerCase)
    PerCase.stub!(:new).and_return(@per_case)
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
  
  specify "should create an new per_case" do
    PerCase.should_receive(:new).and_return(@per_case)
    do_get
  end
  
  specify "should not save the new per_case" do
    @per_case.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new per_case for the view" do
    do_get
    assigns[:per_case].should be(@per_case)
  end
end

context "Requesting /per_cases/1;edit using GET" do
  controller_name :per_cases

  setup do
    @per_case = mock_model(PerCase)
    PerCase.stub!(:find).and_return(@per_case)
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
  
  specify "should find the per_case requested" do
    PerCase.should_receive(:find).and_return(@per_case)
    do_get
  end
  
  specify "should assign the found PerCase for the view" do
    do_get
    assigns[:per_case].should equal(@per_case)
  end
end

context "Requesting /per_cases using POST" do
  controller_name :per_cases

  setup do
    @per_case = mock_model(PerCase, :to_param => "1", :save => true)
    PerCase.stub!(:new).and_return(@per_case)
  end
  
  def do_post
    post :create, :per_case => {:name => 'PerCase'}
  end
  
  specify "should create a new per_case" do
    PerCase.should_receive(:new).with({'name' => 'PerCase'}).and_return(@per_case)
    do_post
  end

  specify "should redirect to the new per_case" do
    do_post
    response.should redirect_to("http://test.host/per_cases/1")
  end
end

context "Requesting /per_cases/1 using PUT" do
  controller_name :per_cases

  setup do
    @per_case = mock_model(PerCase, :to_param => "1", :update_attributes => true)
    PerCase.stub!(:find).and_return(@per_case)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the per_case requested" do
    PerCase.should_receive(:find).with("1").and_return(@per_case)
    do_update
  end

  specify "should update the found per_case" do
    @per_case.should_receive(:update_attributes)
    do_update
    assigns(:per_case).should equal(@per_case)
  end

  specify "should assign the found per_case for the view" do
    do_update
    assigns(:per_case).should equal(@per_case)
  end

  specify "should redirect to the per_case" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/per_cases/1"
  end
end

context "Requesting /per_cases/1 using DELETE" do
  controller_name :per_cases

  setup do
    @per_case = mock_model(PerCase, :destroy => true)
    PerCase.stub!(:find).and_return(@per_case)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the per_case requested" do
    PerCase.should_receive(:find).with("1").and_return(@per_case)
    do_delete
  end
  
  specify "should call destroy on the found per_case" do
    @per_case.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the per_cases list" do
    do_delete
    response.should redirect_to("http://test.host/per_cases")
  end
end