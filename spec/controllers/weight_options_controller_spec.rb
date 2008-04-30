require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the WeightOptionsController should map" do
  controller_name :weight_options

  specify "{ :controller => 'weight_options', :action => 'index' } to /weight_options" do
    route_for(:controller => "weight_options", :action => "index").should == "/weight_options"
  end
  
  specify "{ :controller => 'weight_options', :action => 'new' } to /weight_options/new" do
    route_for(:controller => "weight_options", :action => "new").should == "/weight_options/new"
  end
  
  specify "{ :controller => 'weight_options', :action => 'show', :id => 1 } to /weight_options/1" do
    route_for(:controller => "weight_options", :action => "show", :id => 1).should == "/weight_options/1"
  end
  
  specify "{ :controller => 'weight_options', :action => 'edit', :id => 1 } to /weight_options/1;edit" do
    route_for(:controller => "weight_options", :action => "edit", :id => 1).should == "/weight_options/1;edit"
  end
  
  specify "{ :controller => 'weight_options', :action => 'update', :id => 1} to /weight_options/1" do
    route_for(:controller => "weight_options", :action => "update", :id => 1).should == "/weight_options/1"
  end
  
  specify "{ :controller => 'weight_options', :action => 'destroy', :id => 1} to /weight_options/1" do
    route_for(:controller => "weight_options", :action => "destroy", :id => 1).should == "/weight_options/1"
  end
end

context "Requesting /weight_options using GET" do
  controller_name :weight_options

  setup do
    @weight_option = mock_model(WeightOption)
    WeightOption.stub!(:find).and_return(@weight_option)
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
  
  specify "should find all weight_options" do
    WeightOption.should_receive(:find).with(:all).and_return([@weight_option])
    do_get
  end
  
  specify "should assign the found weight_options for the view" do
    do_get
    assigns[:weight_options].should equal(@weight_option)
  end
end

context "Requesting /weight_options.xml using GET" do
  controller_name :weight_options

  setup do
    @weight_option = mock_model(WeightOption, :to_xml => "XML")
    WeightOption.stub!(:find).and_return(@weight_option)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all weight_options" do
    WeightOption.should_receive(:find).with(:all).and_return([@weight_option])
    do_get
  end
  
  specify "should render the found weight_options as xml" do
    @weight_option.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /weight_options/1 using GET" do
  controller_name :weight_options

  setup do
    @weight_option = mock_model(WeightOption)
    WeightOption.stub!(:find).and_return(@weight_option)
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
  
  specify "should find the weight_option requested" do
    WeightOption.should_receive(:find).with("1").and_return(@weight_option)
    do_get
  end
  
  specify "should assign the found weight_option for the view" do
    do_get
    assigns[:weight_option].should equal(@weight_option)
  end
end

context "Requesting /weight_options/1.xml using GET" do
  controller_name :weight_options

  setup do
    @weight_option = mock_model(WeightOption, :to_xml => "XML")
    WeightOption.stub!(:find).and_return(@weight_option)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the weight_option requested" do
    WeightOption.should_receive(:find).with("1").and_return(@weight_option)
    do_get
  end
  
  specify "should render the found weight_option as xml" do
    @weight_option.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /weight_options/new using GET" do
  controller_name :weight_options

  setup do
    @weight_option = mock_model(WeightOption)
    WeightOption.stub!(:new).and_return(@weight_option)
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
  
  specify "should create an new weight_option" do
    WeightOption.should_receive(:new).and_return(@weight_option)
    do_get
  end
  
  specify "should not save the new weight_option" do
    @weight_option.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new weight_option for the view" do
    do_get
    assigns[:weight_option].should be(@weight_option)
  end
end

context "Requesting /weight_options/1;edit using GET" do
  controller_name :weight_options

  setup do
    @weight_option = mock_model(WeightOption)
    WeightOption.stub!(:find).and_return(@weight_option)
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
  
  specify "should find the weight_option requested" do
    WeightOption.should_receive(:find).and_return(@weight_option)
    do_get
  end
  
  specify "should assign the found WeightOption for the view" do
    do_get
    assigns[:weight_option].should equal(@weight_option)
  end
end

context "Requesting /weight_options using POST" do
  controller_name :weight_options

  setup do
    @weight_option = mock_model(WeightOption, :to_param => "1", :save => true)
    WeightOption.stub!(:new).and_return(@weight_option)
  end
  
  def do_post
    post :create, :weight_option => {:name => 'WeightOption'}
  end
  
  specify "should create a new weight_option" do
    WeightOption.should_receive(:new).with({'name' => 'WeightOption'}).and_return(@weight_option)
    do_post
  end

  specify "should redirect to the new weight_option" do
    do_post
    response.should redirect_to("http://test.host/weight_options/1")
  end
end

context "Requesting /weight_options/1 using PUT" do
  controller_name :weight_options

  setup do
    @weight_option = mock_model(WeightOption, :to_param => "1", :update_attributes => true)
    WeightOption.stub!(:find).and_return(@weight_option)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the weight_option requested" do
    WeightOption.should_receive(:find).with("1").and_return(@weight_option)
    do_update
  end

  specify "should update the found weight_option" do
    @weight_option.should_receive(:update_attributes)
    do_update
    assigns(:weight_option).should equal(@weight_option)
  end

  specify "should assign the found weight_option for the view" do
    do_update
    assigns(:weight_option).should equal(@weight_option)
  end

  specify "should redirect to the weight_option" do
    do_update
    response.should be_redirect
    response.redirect_url.should == "http://test.host/weight_options/1"
  end
end

context "Requesting /weight_options/1 using DELETE" do
  controller_name :weight_options

  setup do
    @weight_option = mock_model(WeightOption, :destroy => true)
    WeightOption.stub!(:find).and_return(@weight_option)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the weight_option requested" do
    WeightOption.should_receive(:find).with("1").and_return(@weight_option)
    do_delete
  end
  
  specify "should call destroy on the found weight_option" do
    @weight_option.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the weight_options list" do
    do_delete
    response.should redirect_to("http://test.host/weight_options")
  end
end