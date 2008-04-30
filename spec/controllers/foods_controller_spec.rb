require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the FoodsController should map" do
  controller_name :foods

  specify "{ :controller => 'foods', :action => 'index' } to /foods" do
    route_for(:controller => "foods", :action => "index").should == "/foods"
  end
  
  specify "{ :controller => 'foods', :action => 'new' } to /foods/new" do
    route_for(:controller => "foods", :action => "new").should == "/foods/new"
  end
  
  specify "{ :controller => 'foods', :action => 'show', :id => 1 } to /foods/1" do
    route_for(:controller => "foods", :action => "show", :id => 1).should == "/foods/1"
  end
  
  specify "{ :controller => 'foods', :action => 'edit', :id => 1 } to /foods/1;edit" do
    route_for(:controller => "foods", :action => "edit", :id => 1).should == "/foods/1;edit"
  end
  
  specify "{ :controller => 'foods', :action => 'update', :id => 1} to /foods/1" do
    route_for(:controller => "foods", :action => "update", :id => 1).should == "/foods/1"
  end
  
  specify "{ :controller => 'foods', :action => 'destroy', :id => 1} to /foods/1" do
    route_for(:controller => "foods", :action => "destroy", :id => 1).should == "/foods/1"
  end
end

context "Requesting /foods using GET" do
  controller_name :foods

  setup do
    @food = mock_model(Food)
    Food.stub!(:find).and_return(@food)
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
  
  specify "should find all foods" do
    Food.should_receive(:find).with(:all).and_return([@food])
    do_get
  end
  
  specify "should assign the found foods for the view" do
    do_get
    assigns[:foods].should equal(@food)
  end
end

context "Requesting /foods.xml using GET" do
  controller_name :foods

  setup do
    @food = mock_model(Food, :to_xml => "XML")
    Food.stub!(:find).and_return(@food)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all foods" do
    Food.should_receive(:find).with(:all).and_return([@food])
    do_get
  end
  
  specify "should render the found foods as xml" do
    @food.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /foods/1 using GET" do
  controller_name :foods

  setup do
    @food = mock_model(Food)
    Food.stub!(:find).and_return(@food)
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
  
  specify "should find the food requested" do
    Food.should_receive(:find).with("1").and_return(@food)
    do_get
  end
  
  specify "should assign the found food for the view" do
    do_get
    assigns[:food].should equal(@food)
  end
end

context "Requesting /foods/1.xml using GET" do
  controller_name :foods

  setup do
    @food = mock_model(Food, :to_xml => "XML")
    Food.stub!(:find).and_return(@food)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the food requested" do
    Food.should_receive(:find).with("1").and_return(@food)
    do_get
  end
  
  specify "should render the found food as xml" do
    @food.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /foods/new using GET" do
  controller_name :foods

  setup do
    @food = mock_model(Food)
    Food.stub!(:new).and_return(@food)
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
  
  specify "should create an new food" do
    Food.should_receive(:new).and_return(@food)
    do_get
  end
  
  specify "should not save the new food" do
    @food.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new food for the view" do
    do_get
    assigns[:food].should be(@food)
  end
end

context "Requesting /foods/1;edit using GET" do
  controller_name :foods

  setup do
    @food = mock_model(Food)
    Food.stub!(:find).and_return(@food)
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
  
  specify "should find the food requested" do
    Food.should_receive(:find).and_return(@food)
    do_get
  end
  
  specify "should assign the found Food for the view" do
    do_get
    assigns[:food].should equal(@food)
  end
end

context "Requesting /foods using POST" do
  controller_name :foods

  setup do
    @food = mock_model(Food, :to_param => "1", :save => true)
    Food.stub!(:new).and_return(@food)
  end
  
  def do_post
    post :create, :food => {:name => 'Food'}
  end
  
  specify "should create a new food" do
    Food.should_receive(:new).with({'name' => 'Food'}).and_return(@food)
    do_post
  end

  specify "should redirect to the new food" do
    do_post
    response.should redirect_to("http://test.host/foods/1")
  end
end

context "Requesting /foods/1 using PUT" do
  controller_name :foods

  setup do
    @food = mock_model(Food, :to_param => "1", :update_attributes => true)
    Food.stub!(:find).and_return(@food)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the food requested" do
    Food.should_receive(:find).with("1").and_return(@food)
    do_update
  end

  specify "should update the found food" do
    @food.should_receive(:update_attributes)
    do_update
    assigns(:food).should equal(@food)
  end

  specify "should assign the found food for the view" do
    do_update
    assigns(:food).should equal(@food)
  end

  specify "should redirect to the food" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/foods/1"
  end
end

context "Requesting /foods/1 using DELETE" do
  controller_name :foods

  setup do
    @food = mock_model(Food, :destroy => true)
    Food.stub!(:find).and_return(@food)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the food requested" do
    Food.should_receive(:find).with("1").and_return(@food)
    do_delete
  end
  
  specify "should call destroy on the found food" do
    @food.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the foods list" do
    do_delete
    response.should redirect_to("http://test.host/foods")
  end
end