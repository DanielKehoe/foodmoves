require File.dirname(__FILE__) + '/../spec_helper'

RAILS_ROOT = File.dirname(__FILE__) + "/../fixtures"

class BaseController
  stub!(:helper_method)
  include Roar::Rails::BaseController
end
BaseController.send(:extend, Roar::Rails::ActMethods)

context "The Base Controller" do
  specify "should contain the class method roar" do
    BaseController.methods.should_include("roar")    
  end
end

context "A TestControllerController with a blank roar" do
  class TestController < BaseController
  end
  TestController.stub!(:helper_method)
  TestController.stub!(:before_filter)
  
  class TestController
    roar {}
  end
  
  setup do
    @request = mock('request')
    @controller = TestController.new
    @controller.stub!(:request).and_return(@request)
  end
  
  specify "should use model_name of Test" do
    @controller.model_name.should == "Test"
  end
  
  specify "should have a collection symbol of :tests" do
    @controller.collection_symbol.should == :tests
  end
  
  specify "should have a model symbol of :test" do
    @controller.model_symbol.should == :test
  end

  specify "should have a model class of Test" do
    @controller.model_class.should == Test
  end
    
  specify "should respond to index" do
    @controller.methods.should include("index")
  end
end

context "A Controller with a custom roar action specified" do
  class Preview
  end
  class PreviewController < BaseController
  end
  PreviewController.stub!(:helper_method)
  PreviewController.stub!(:before_filter)
  class PreviewController < BaseController
    roar {}
    roar_action :preview do
    end
  end
  
  setup do
    @controller = PreviewController.new
  end
  
  specify "should respond to preview" do
    @controller.methods.should include("preview") 
  end  
end
  

context "A Controller with subdomain specified" do
  class Subdomain
  end

  class SubdomainController < BaseController
    stub!(:helper_method)
    stub!(:before_filter)
    roar(:subdomain=>"admin") {}
  end
  
  setup do
    @template_paths = Roar::Settings.template_paths
    @controller = SubdomainController.new
    @request = mock('request')
    @request.stub!(:subdomains).and_return(["admin"])
    @request.stub!(:path).and_return("/")
    
    @controller.stub!(:controller_path).and_return("subdomain")
    @controller.stub!(:params).and_return({})
    @controller.stub!(:request).and_return(@request)
    @default = "/../../vendor/plugins/roar/views/default"
  end
  
  teardown do
    Roar::Settings.template_paths = @template_paths
  end
  
  specify "should not respond to index" do
    @controller.methods.should_not include("index")
  end
  
  specify "should respond to admin_index" do
    @controller.methods.should include("admin_index")
  end
  
  specify "should return default view when not overriden by app" do
    @controller.roar_path("atemplate").should == @default+"/atemplate"
  end
  
  specify "should return overriden view when view exists" do
    @controller.roar_path("new").should == "subdomain/admin/new"
  end
  
  specify "should return local view when local path has been set" do
    Roar::Settings.insert_template_path("/../../local/")
    @controller.roar_path("show").should == "/../../local/default/show"
  end

  specify "should return path to rjs file" do
    @controller.roar_path("update", :ext=>'.rjs').should == @default+"/update.rjs"
  end

  specify "should return partial path if it exists in the app directory" do
    @controller.roar_path("mypartial", :partial=>true).should == "subdomain/admin/mypartial"
  end
  
  specify "should return template path if no file is found" do
    @controller.roar_path("blah").should == "admin/blah"
  end
  
  specify "should return template path if given a partial in a directory" do
    @controller.roar_path("fields/field", :partial=>true).should == @default+"/fields/field"  
  end
end

context "A Controller with view set to simple" do
  class Simple
  end
  
  class SimpleController < BaseController
    stub!(:helper_method)
    stub!(:before_filter)
    roar(:view=>"simple") {}
  end
  
  setup do
    @request = mock('request')
    @request.stub!(:subdomains).and_return([])
    @request.stub!(:path).and_return("/")
    @template_paths = Roar::Settings.template_paths
    @controller = SimpleController.new
    @controller.stub!(:controller_path).and_return("simple")
    @controller.stub!(:params).and_return({})
    @controller.stub!(:request).and_return(@request)
  end

  specify "should have a view of simple" do
    @controller.roar.view.should == "simple"
  end
  
  specify "should return default view when not overriden by app" do
    @controller.roar_path("index").should == \
      "/../../vendor/plugins/roar/views/simple/index"
  end

  specify "should return overriden view when it exists" do
    @controller.roar_path("new").should ==  "simple/new"
  end
    
  specify "should return local view when local path has been set" do
    Roar::Settings.insert_template_path("/../../local/")
    @controller.roar_path("show").should == "/../../local/simple/show"
  end
  
  specify "should fallback to default view if all else fails" do
    @controller.roar_path("update", :ext=>'.rjs').should == \
      "/../../vendor/plugins/roar/views/default/update.rjs"
  end
end

context "A controller with an admin specified" do
  class TestController < BaseController
    roar {
      per_page 20
    }
  end
  
  setup do
    @request = mock('request')
    @request.stub!(:subdomains).and_return([])
    @request.stub!(:path).and_return("/")
    @controller = TestController.new
    @controller.stub!(:request).and_return(@request)
  end
  
  specify "should have a roar::admin object" do
    @controller.roar.per_page.should == 20
  end
  
  
end
