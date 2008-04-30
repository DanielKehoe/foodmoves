require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the ConditionsController should map" do
  controller_name :conditions

  specify "{ :controller => 'conditions', :action => 'index' } to /conditions" do
    route_for(:controller => "conditions", :action => "index").should == "/conditions"
  end
  
  specify "{ :controller => 'conditions', :action => 'new' } to /conditions/new" do
    route_for(:controller => "conditions", :action => "new").should == "/conditions/new"
  end
  
  specify "{ :controller => 'conditions', :action => 'show', :id => 1 } to /conditions/1" do
    route_for(:controller => "conditions", :action => "show", :id => 1).should == "/conditions/1"
  end
  
  specify "{ :controller => 'conditions', :action => 'edit', :id => 1 } to /conditions/1;edit" do
    route_for(:controller => "conditions", :action => "edit", :id => 1).should == "/conditions/1;edit"
  end
  
  specify "{ :controller => 'conditions', :action => 'update', :id => 1} to /conditions/1" do
    route_for(:controller => "conditions", :action => "update", :id => 1).should == "/conditions/1"
  end
  
  specify "{ :controller => 'conditions', :action => 'destroy', :id => 1} to /conditions/1" do
    route_for(:controller => "conditions", :action => "destroy", :id => 1).should == "/conditions/1"
  end
end

context "Requesting /conditions using GET" do
  controller_name :conditions

  setup do
    @condition = mock_model(Condition)
    Condition.stub!(:find).and_return(@condition)
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
  
  specify "should find all conditions" do
    Condition.should_receive(:find).with(:all).and_return([@condition])
    do_get
  end
  
  specify "should assign the found conditions for the view" do
    do_get
    assigns[:conditions].should equal(@condition)
  end
end

context "Requesting /conditions.xml using GET" do
  controller_name :conditions

  setup do
    @condition = mock_model(Condition, :to_xml => "XML")
    Condition.stub!(:find).and_return(@condition)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all conditions" do
    Condition.should_receive(:find).with(:all).and_return([@condition])
    do_get
  end
  
  specify "should render the found conditions as xml" do
    @condition.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /conditions/1 using GET" do
  controller_name :conditions

  setup do
    @condition = mock_model(Condition)
    Condition.stub!(:find).and_return(@condition)
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
  
  specify "should find the condition requested" do
    Condition.should_receive(:find).with("1").and_return(@condition)
    do_get
  end
  
  specify "should assign the found condition for the view" do
    do_get
    assigns[:condition].should equal(@condition)
  end
end

context "Requesting /conditions/1.xml using GET" do
  controller_name :conditions

  setup do
    @condition = mock_model(Condition, :to_xml => "XML")
    Condition.stub!(:find).and_return(@condition)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the condition requested" do
    Condition.should_receive(:find).with("1").and_return(@condition)
    do_get
  end
  
  specify "should render the found condition as xml" do
    @condition.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /conditions/new using GET" do
  controller_name :conditions

  setup do
    @condition = mock_model(Condition)
    Condition.stub!(:new).and_return(@condition)
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
  
  specify "should create an new condition" do
    Condition.should_receive(:new).and_return(@condition)
    do_get
  end
  
  specify "should not save the new condition" do
    @condition.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new condition for the view" do
    do_get
    assigns[:condition].should be(@condition)
  end
end

context "Requesting /conditions/1;edit using GET" do
  controller_name :conditions

  setup do
    @condition = mock_model(Condition)
    Condition.stub!(:find).and_return(@condition)
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
  
  specify "should find the condition requested" do
    Condition.should_receive(:find).and_return(@condition)
    do_get
  end
  
  specify "should assign the found Condition for the view" do
    do_get
    assigns[:condition].should equal(@condition)
  end
end

context "Requesting /conditions using POST" do
  controller_name :conditions

  setup do
    @condition = mock_model(Condition, :to_param => "1", :save => true)
    Condition.stub!(:new).and_return(@condition)
  end
  
  def do_post
    post :create, :condition => {:name => 'Condition'}
  end
  
  specify "should create a new condition" do
    Condition.should_receive(:new).with({'name' => 'Condition'}).and_return(@condition)
    do_post
  end

  specify "should redirect to the new condition" do
    do_post
    response.should redirect_to("http://test.host/conditions/1")
  end
end

context "Requesting /conditions/1 using PUT" do
  controller_name :conditions

  setup do
    @condition = mock_model(Condition, :to_param => "1", :update_attributes => true)
    Condition.stub!(:find).and_return(@condition)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the condition requested" do
    Condition.should_receive(:find).with("1").and_return(@condition)
    do_update
  end

  specify "should update the found condition" do
    @condition.should_receive(:update_attributes)
    do_update
    assigns(:condition).should equal(@condition)
  end

  specify "should assign the found condition for the view" do
    do_update
    assigns(:condition).should equal(@condition)
  end

  specify "should redirect to the condition" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/conditions/1"
  end
end

context "Requesting /conditions/1 using DELETE" do
  controller_name :conditions

  setup do
    @condition = mock_model(Condition, :destroy => true)
    Condition.stub!(:find).and_return(@condition)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the condition requested" do
    Condition.should_receive(:find).with("1").and_return(@condition)
    do_delete
  end
  
  specify "should call destroy on the found condition" do
    @condition.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the conditions list" do
    do_delete
    response.should redirect_to("http://test.host/conditions")
  end
end