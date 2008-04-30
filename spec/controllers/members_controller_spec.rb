require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the MembersController should map" do
  controller_name :members

  specify "{ :controller => 'members', :action => 'index' } to /members" do
    route_for(:controller => "members", :action => "index").should == "/members"
  end
  
  specify "{ :controller => 'members', :action => 'new' } to /members/new" do
    route_for(:controller => "members", :action => "new").should == "/members/new"
  end
  
  specify "{ :controller => 'members', :action => 'show', :id => 1 } to /members/1" do
    route_for(:controller => "members", :action => "show", :id => 1).should == "/members/1"
  end
  
  specify "{ :controller => 'members', :action => 'edit', :id => 1 } to /members/1;edit" do
    route_for(:controller => "members", :action => "edit", :id => 1).should == "/members/1;edit"
  end
  
  specify "{ :controller => 'members', :action => 'update', :id => 1} to /members/1" do
    route_for(:controller => "members", :action => "update", :id => 1).should == "/members/1"
  end
  
  specify "{ :controller => 'members', :action => 'destroy', :id => 1} to /members/1" do
    route_for(:controller => "members", :action => "destroy", :id => 1).should == "/members/1"
  end
end

context "Requesting /members using GET" do
  controller_name :members

  setup do
    @member = mock_model(Member)
    Member.stub!(:find).and_return(@member)
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
  
  specify "should find all members" do
    Member.should_receive(:find).with(:all).and_return([@member])
    do_get
  end
  
  specify "should assign the found members for the view" do
    do_get
    assigns[:members].should equal(@member)
  end
end

context "Requesting /members.xml using GET" do
  controller_name :members

  setup do
    @member = mock_model(Member, :to_xml => "XML")
    Member.stub!(:find).and_return(@member)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all members" do
    Member.should_receive(:find).with(:all).and_return([@member])
    do_get
  end
  
  specify "should render the found members as xml" do
    @member.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /members/1 using GET" do
  controller_name :members

  setup do
    @member = mock_model(Member)
    Member.stub!(:find).and_return(@member)
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
  
  specify "should find the member requested" do
    Member.should_receive(:find).with("1").and_return(@member)
    do_get
  end
  
  specify "should assign the found member for the view" do
    do_get
    assigns[:member].should equal(@member)
  end
end

context "Requesting /members/1.xml using GET" do
  controller_name :members

  setup do
    @member = mock_model(Member, :to_xml => "XML")
    Member.stub!(:find).and_return(@member)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the member requested" do
    Member.should_receive(:find).with("1").and_return(@member)
    do_get
  end
  
  specify "should render the found member as xml" do
    @member.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /members/new using GET" do
  controller_name :members

  setup do
    @member = mock_model(Member)
    Member.stub!(:new).and_return(@member)
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
  
  specify "should create an new member" do
    Member.should_receive(:new).and_return(@member)
    do_get
  end
  
  specify "should not save the new member" do
    @member.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new member for the view" do
    do_get
    assigns[:member].should be(@member)
  end
end

context "Requesting /members/1;edit using GET" do
  controller_name :members

  setup do
    @member = mock_model(Member)
    Member.stub!(:find).and_return(@member)
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
  
  specify "should find the member requested" do
    Member.should_receive(:find).and_return(@member)
    do_get
  end
  
  specify "should assign the found Member for the view" do
    do_get
    assigns[:member].should equal(@member)
  end
end

context "Requesting /members using POST" do
  controller_name :members

  setup do
    @member = mock_model(Member, :to_param => "1", :save => true)
    Member.stub!(:new).and_return(@member)
  end
  
  def do_post
    post :create, :member => {:name => 'Member'}
  end
  
  specify "should create a new member" do
    Member.should_receive(:new).with({'name' => 'Member'}).and_return(@member)
    do_post
  end

  specify "should redirect to the new member" do
    do_post
    response.should redirect_to("http://test.host/members/1")
  end
end

context "Requesting /members/1 using PUT" do
  controller_name :members

  setup do
    @member = mock_model(Member, :to_param => "1", :update_attributes => true)
    Member.stub!(:find).and_return(@member)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the member requested" do
    Member.should_receive(:find).with("1").and_return(@member)
    do_update
  end

  specify "should update the found member" do
    @member.should_receive(:update_attributes)
    do_update
    assigns(:member).should equal(@member)
  end

  specify "should assign the found member for the view" do
    do_update
    assigns(:member).should equal(@member)
  end

  specify "should redirect to the member" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/members/1"
  end
end

context "Requesting /members/1 using DELETE" do
  controller_name :members

  setup do
    @member = mock_model(Member, :destroy => true)
    Member.stub!(:find).and_return(@member)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the member requested" do
    Member.should_receive(:find).with("1").and_return(@member)
    do_delete
  end
  
  specify "should call destroy on the found member" do
    @member.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the members list" do
    do_delete
    response.should redirect_to("http://test.host/members")
  end
end