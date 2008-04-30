require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the CertificationsController should map" do
  controller_name :certifications

  specify "{ :controller => 'certifications', :action => 'index' } to /certifications" do
    route_for(:controller => "certifications", :action => "index").should == "/certifications"
  end
  
  specify "{ :controller => 'certifications', :action => 'new' } to /certifications/new" do
    route_for(:controller => "certifications", :action => "new").should == "/certifications/new"
  end
  
  specify "{ :controller => 'certifications', :action => 'show', :id => 1 } to /certifications/1" do
    route_for(:controller => "certifications", :action => "show", :id => 1).should == "/certifications/1"
  end
  
  specify "{ :controller => 'certifications', :action => 'edit', :id => 1 } to /certifications/1;edit" do
    route_for(:controller => "certifications", :action => "edit", :id => 1).should == "/certifications/1;edit"
  end
  
  specify "{ :controller => 'certifications', :action => 'update', :id => 1} to /certifications/1" do
    route_for(:controller => "certifications", :action => "update", :id => 1).should == "/certifications/1"
  end
  
  specify "{ :controller => 'certifications', :action => 'destroy', :id => 1} to /certifications/1" do
    route_for(:controller => "certifications", :action => "destroy", :id => 1).should == "/certifications/1"
  end
end

context "Requesting /certifications using GET" do
  controller_name :certifications

  setup do
    @certification = mock_model(Certification)
    Certification.stub!(:find).and_return(@certification)
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
  
  specify "should find all certifications" do
    Certification.should_receive(:find).with(:all).and_return([@certification])
    do_get
  end
  
  specify "should assign the found certifications for the view" do
    do_get
    assigns[:certifications].should equal(@certification)
  end
end

context "Requesting /certifications.xml using GET" do
  controller_name :certifications

  setup do
    @certification = mock_model(Certification, :to_xml => "XML")
    Certification.stub!(:find).and_return(@certification)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all certifications" do
    Certification.should_receive(:find).with(:all).and_return([@certification])
    do_get
  end
  
  specify "should render the found certifications as xml" do
    @certification.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /certifications/1 using GET" do
  controller_name :certifications

  setup do
    @certification = mock_model(Certification)
    Certification.stub!(:find).and_return(@certification)
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
  
  specify "should find the certification requested" do
    Certification.should_receive(:find).with("1").and_return(@certification)
    do_get
  end
  
  specify "should assign the found certification for the view" do
    do_get
    assigns[:certification].should equal(@certification)
  end
end

context "Requesting /certifications/1.xml using GET" do
  controller_name :certifications

  setup do
    @certification = mock_model(Certification, :to_xml => "XML")
    Certification.stub!(:find).and_return(@certification)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the certification requested" do
    Certification.should_receive(:find).with("1").and_return(@certification)
    do_get
  end
  
  specify "should render the found certification as xml" do
    @certification.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /certifications/new using GET" do
  controller_name :certifications

  setup do
    @certification = mock_model(Certification)
    Certification.stub!(:new).and_return(@certification)
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
  
  specify "should create an new certification" do
    Certification.should_receive(:new).and_return(@certification)
    do_get
  end
  
  specify "should not save the new certification" do
    @certification.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new certification for the view" do
    do_get
    assigns[:certification].should be(@certification)
  end
end

context "Requesting /certifications/1;edit using GET" do
  controller_name :certifications

  setup do
    @certification = mock_model(Certification)
    Certification.stub!(:find).and_return(@certification)
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
  
  specify "should find the certification requested" do
    Certification.should_receive(:find).and_return(@certification)
    do_get
  end
  
  specify "should assign the found Certification for the view" do
    do_get
    assigns[:certification].should equal(@certification)
  end
end

context "Requesting /certifications using POST" do
  controller_name :certifications

  setup do
    @certification = mock_model(Certification, :to_param => "1", :save => true)
    Certification.stub!(:new).and_return(@certification)
  end
  
  def do_post
    post :create, :certification => {:name => 'Certification'}
  end
  
  specify "should create a new certification" do
    Certification.should_receive(:new).with({'name' => 'Certification'}).and_return(@certification)
    do_post
  end

  specify "should redirect to the new certification" do
    do_post
    response.should redirect_to("http://test.host/certifications/1")
  end
end

context "Requesting /certifications/1 using PUT" do
  controller_name :certifications

  setup do
    @certification = mock_model(Certification, :to_param => "1", :update_attributes => true)
    Certification.stub!(:find).and_return(@certification)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the certification requested" do
    Certification.should_receive(:find).with("1").and_return(@certification)
    do_update
  end

  specify "should update the found certification" do
    @certification.should_receive(:update_attributes)
    do_update
    assigns(:certification).should equal(@certification)
  end

  specify "should assign the found certification for the view" do
    do_update
    assigns(:certification).should equal(@certification)
  end

  specify "should redirect to the certification" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/certifications/1"
  end
end

context "Requesting /certifications/1 using DELETE" do
  controller_name :certifications

  setup do
    @certification = mock_model(Certification, :destroy => true)
    Certification.stub!(:find).and_return(@certification)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the certification requested" do
    Certification.should_receive(:find).with("1").and_return(@certification)
    do_delete
  end
  
  specify "should call destroy on the found certification" do
    @certification.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the certifications list" do
    do_delete
    response.should redirect_to("http://test.host/certifications")
  end
end