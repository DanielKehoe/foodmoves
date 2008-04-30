require File.dirname(__FILE__) + '/../spec_helper'
require 'roar/filter_set'

class News
end
News.stub!(:table_name).and_return("news")
News.stub!(:reflect_on_association).and_return(nil)
News.stub!(:column_methods_hash).and_return({:title=>"title"})

context "A filter set with one search field" do
  setup do
    @controller = mock('controller')
    @controller.stub!(:model_class).and_return(News)
    @controller.stub!(:params).and_return({})
  end
  
  specify "should not define filter when params are empty" do
    filterset = Roar::FilterSet.new(@controller) {
      search :text, :fields => :title
    }.query.conditions.should == nil
  end
  
  specify "should define the filter when params are given" do
    @controller.stub!(:params).and_return({:text=>"hey"})
    filterset = Roar::FilterSet.new(@controller) {
      search :text, :fields => :title
    }.query.conditions.should == " (   (  ( news.title LIKE ? )  )   ) "
  end  
  
  specify "should allow multiple search filters" do
    @controller.stub!(:params).and_return({:title=>"hey", :body=>"yo"})
    filterset = Roar::FilterSet.new(@controller) {
      search :title, :fields => :title
      search :body, :fields => :body
    }.query.conditions.should_match /news.body LIKE ?/
  end
  
  specify "should only define filters that have parameters" do
    @controller.stub!(:params).and_return({:title=>"hey", :body=>""})
    filterset = Roar::FilterSet.new(@controller) {
      search :title, :fields => :title
      search :body, :fields => :body
    }.query.conditions.should_not_match /news.body LIKE ?/
  end
  
  specify "should allow multiple search filters" do
    filterset = Roar::FilterSet.new(@controller) {
      search :title, :fields => :title
      search :body, :fields => :body
    }.entries.first.name.should == :title
  end
  
  specify "should use the default view" do
    filterset = Roar::FilterSet.new(@controller) {}
    filterset.view.should == "default"
  end
end

