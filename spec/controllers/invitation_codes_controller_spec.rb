require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the InvitationCodesController should map" do
  controller_name :invitation_codes

  specify "{ :controller => 'invitation_codes', :action => 'index' } to /invitation_codes" do
    route_for(:controller => "invitation_codes", :action => "index").should == "/invitation_codes"
  end
  
  specify "{ :controller => 'invitation_codes', :action => 'new' } to /invitation_codes/new" do
    route_for(:controller => "invitation_codes", :action => "new").should == "/invitation_codes/new"
  end
  
  specify "{ :controller => 'invitation_codes', :action => 'show', :id => 1 } to /invitation_codes/1" do
    route_for(:controller => "invitation_codes", :action => "show", :id => 1).should == "/invitation_codes/1"
  end
  
  specify "{ :controller => 'invitation_codes', :action => 'edit', :id => 1 } to /invitation_codes/1;edit" do
    route_for(:controller => "invitation_codes", :action => "edit", :id => 1).should == "/invitation_codes/1;edit"
  end
  
  specify "{ :controller => 'invitation_codes', :action => 'update', :id => 1} to /invitation_codes/1" do
    route_for(:controller => "invitation_codes", :action => "update", :id => 1).should == "/invitation_codes/1"
  end
  
  specify "{ :controller => 'invitation_codes', :action => 'destroy', :id => 1} to /invitation_codes/1" do
    route_for(:controller => "invitation_codes", :action => "destroy", :id => 1).should == "/invitation_codes/1"
  end
end

context "Requesting /invitation_codes using GET" do
  controller_name :invitation_codes

  setup do
    @invitation_code = mock_model(InvitationCode)
    InvitationCode.stub!(:find).and_return(@invitation_code)
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
  
  specify "should find all invitation_codes" do
    InvitationCode.should_receive(:find).with(:all).and_return([@invitation_code])
    do_get
  end
  
  specify "should assign the found invitation_codes for the view" do
    do_get
    assigns[:invitation_codes].should equal(@invitation_code)
  end
end

context "Requesting /invitation_codes.xml using GET" do
  controller_name :invitation_codes

  setup do
    @invitation_code = mock_model(InvitationCode, :to_xml => "XML")
    InvitationCode.stub!(:find).and_return(@invitation_code)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all invitation_codes" do
    InvitationCode.should_receive(:find).with(:all).and_return([@invitation_code])
    do_get
  end
  
  specify "should render the found invitation_codes as xml" do
    @invitation_code.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /invitation_codes/1 using GET" do
  controller_name :invitation_codes

  setup do
    @invitation_code = mock_model(InvitationCode)
    InvitationCode.stub!(:find).and_return(@invitation_code)
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
  
  specify "should find the invitation_code requested" do
    InvitationCode.should_receive(:find).with("1").and_return(@invitation_code)
    do_get
  end
  
  specify "should assign the found invitation_code for the view" do
    do_get
    assigns[:invitation_code].should equal(@invitation_code)
  end
end

context "Requesting /invitation_codes/1.xml using GET" do
  controller_name :invitation_codes

  setup do
    @invitation_code = mock_model(InvitationCode, :to_xml => "XML")
    InvitationCode.stub!(:find).and_return(@invitation_code)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the invitation_code requested" do
    InvitationCode.should_receive(:find).with("1").and_return(@invitation_code)
    do_get
  end
  
  specify "should render the found invitation_code as xml" do
    @invitation_code.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /invitation_codes/new using GET" do
  controller_name :invitation_codes

  setup do
    @invitation_code = mock_model(InvitationCode)
    InvitationCode.stub!(:new).and_return(@invitation_code)
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
  
  specify "should create an new invitation_code" do
    InvitationCode.should_receive(:new).and_return(@invitation_code)
    do_get
  end
  
  specify "should not save the new invitation_code" do
    @invitation_code.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new invitation_code for the view" do
    do_get
    assigns[:invitation_code].should be(@invitation_code)
  end
end

context "Requesting /invitation_codes/1;edit using GET" do
  controller_name :invitation_codes

  setup do
    @invitation_code = mock_model(InvitationCode)
    InvitationCode.stub!(:find).and_return(@invitation_code)
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
  
  specify "should find the invitation_code requested" do
    InvitationCode.should_receive(:find).and_return(@invitation_code)
    do_get
  end
  
  specify "should assign the found InvitationCode for the view" do
    do_get
    assigns[:invitation_code].should equal(@invitation_code)
  end
end

context "Requesting /invitation_codes using POST" do
  controller_name :invitation_codes

  setup do
    @invitation_code = mock_model(InvitationCode, :to_param => "1", :save => true)
    InvitationCode.stub!(:new).and_return(@invitation_code)
  end
  
  def do_post
    post :create, :invitation_code => {:name => 'InvitationCode'}
  end
  
  specify "should create a new invitation_code" do
    InvitationCode.should_receive(:new).with({'name' => 'InvitationCode'}).and_return(@invitation_code)
    do_post
  end

  specify "should redirect to the new invitation_code" do
    do_post
    response.should redirect_to("http://test.host/invitation_codes/1")
  end
end

context "Requesting /invitation_codes/1 using PUT" do
  controller_name :invitation_codes

  setup do
    @invitation_code = mock_model(InvitationCode, :to_param => "1", :update_attributes => true)
    InvitationCode.stub!(:find).and_return(@invitation_code)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the invitation_code requested" do
    InvitationCode.should_receive(:find).with("1").and_return(@invitation_code)
    do_update
  end

  specify "should update the found invitation_code" do
    @invitation_code.should_receive(:update_attributes)
    do_update
    assigns(:invitation_code).should equal(@invitation_code)
  end

  specify "should assign the found invitation_code for the view" do
    do_update
    assigns(:invitation_code).should equal(@invitation_code)
  end

  specify "should redirect to the invitation_code" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/invitation_codes/1"
  end
end

context "Requesting /invitation_codes/1 using DELETE" do
  controller_name :invitation_codes

  setup do
    @invitation_code = mock_model(InvitationCode, :destroy => true)
    InvitationCode.stub!(:find).and_return(@invitation_code)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the invitation_code requested" do
    InvitationCode.should_receive(:find).with("1").and_return(@invitation_code)
    do_delete
  end
  
  specify "should call destroy on the found invitation_code" do
    @invitation_code.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the invitation_codes list" do
    do_delete
    response.should redirect_to("http://test.host/invitation_codes")
  end
end