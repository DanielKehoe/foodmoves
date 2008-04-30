require File.dirname(__FILE__) + '/../spec_helper'

class BaseController
end
BaseController.stub!(:helper_method)
BaseController.send(:extend, Roar::Rails::ActMethods)
BaseController.send(:include, Roar::Rails::BaseController)

context "A Controller for a simple model" do
  class Simple
  end
    
  class SimpleController < BaseController
    stub!(:helper_method)
    stub!(:before_filter)
    roar() {}
  end
  
  setup do
    @controller = SimpleController.new
    @controller.stub!(:roar).and_return(Roar::Base.new(self, {}))
    @new_model = Simple.new
    @new_model.stub!(:id).and_return(nil)
    @new_model.stub!(:new_record?).and_return(true)
  end
  
  specify "should return underscored class name for class" do
    @controller.rdom_class(Simple).should == "simple"
  end
  
  specify "should return dash seperated prefix" do
    @controller.rdom_class(Simple, "edit").should == "edit-simple"
  end
    
  specify "should not include model id for dom id of new model" do
    @controller.rdom_id(@new_model).should == "new-simple"
  end
  
  specify "should return dash seperated prefix for dom_id" do
    @controller.rdom_id(@new_model, "new").should == "new-simple"
  end
end

context "A controller with a parent specified" do
  class Parent
  end
  class Child
  end
  
  class ChildController < BaseController
    stub!(:helper_method)
    stub!(:before_filter)
    roar(:parent=>:parent) {}
  end
  
  setup do 
    @controller = ChildController.new
    @controller.stub!(:params).and_return({:parent_id=>'3'})
    @controller.stub!(:roar).and_return(Roar::Base.new(self, {:parent => :parent}))
    @new_model = Child.new
    @new_model.stub!(:id).and_return(nil)
    @new_model.stub!(:new_record?).and_return(true)
    @saved_model = Child.new
    @saved_model.stub!(:id).and_return(2)
    @saved_model.stub!(:new_record?).and_return(false)
  end
  
  specify "should include parent id in dom_class" do
    @controller.rdom_class(Child).should == "child_3"
  end
  
  specify "should include parent id, prefix and model id in dom_id" do
    @controller.rdom_id(@saved_model, 'prefix').should == "prefix-child_3-2"
  end
end
  
  
  

  
  
