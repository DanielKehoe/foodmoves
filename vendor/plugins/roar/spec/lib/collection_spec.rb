require File.dirname(__FILE__) + '/../spec_helper'
require 'roar/collection'

context "A blank collection" do
  setup do
    @controller = mock('NewsController')
    @collection = Roar::Collection.new(Roar::Base.new(@controller))
  end
  
  specify "should have no columns" do
    @collection.columns.should_be_empty
  end
  
  specify "should use default view" do
    @collection.view.should == "default"
  end
  
  specify "should have default per_page" do
    @collection.options.class.should == Hash
    @collection.options[:per_page].should == 10
  end
  
  specify "should have a blank order" do
    @collection.options[:order].should == ""
  end
  
  specify "should have a blank include" do
    @collection.options[:include].should == ""
  end
  
  specify "should have a name of default" do
    @collection.name.should == "default"
  end
end

context "A simple collection" do
  setup do
    @controller = mock('NewsController')
    @collection = simplecollection = Roar::Collection.new(Roar::Base.new(@controller)) do
      column "title"
    end
  end
  
  specify "should specify a column column" do
    @collection.columns.size.should == 1
    @collection.columns.first.name.should == "Title"
  end
  
  specify "should use the default view" do
    @collection.view.should == "default"
  end
end

context "A collection that overrides the default options" do
  setup do
    @controller = mock('NewsController')
    @base = Roar::Base.new(@controller)
  end
  
  specify "should override the default view" do
    @collection = Roar::Collection.new(@base, :view => "simple")
    @collection.view.should == "simple"
  end
  
  specify "should override per_page" do
    Roar::Collection.new(@base, :per_page => 20).options[:per_page].should == 20
  end
  
  specify "should override order" do
    Roar::Collection.new(@base, :order => "created_at DESC").options[:order].should == "created_at DESC"
  end
  
  specify "should override include" do
    Roar::Collection.new(@base, :include => "news_type").options[:include].should == "news_type"
  end
end

context "A collection created from the base" do
  setup do
    @controller = mock('controller')
    @controller.stub!(:params).and_return({})
    @base = Roar::Base.new(@controller)
  end
  
  specify "should have a name of default" do
    @base.collection {}
    @base.collection.name.should == "default"
  end

  specify "should allow defining multiple collections" do
    @base.collection(:name => "First") {}
    @base.collection(:name => "New") {}
    @base.collection {}
    @base.collection(:name => "First").name.should == "First"
    @base.collection(:name => "New").name.should == "New"
    @base.collection(:name => "default").view.should == "default"
    @base.collection.name.should == "First"
  end

  specify "should allow multiple collections with different views" do
    @base.collection(:view => "list") {}
    @base.collection(:view => "collection") {}
    @base.collection(:name => "list").view.should == "list"
  end
  
  specify "should return the collection from the view param" do
    @controller.should_receive(:params).once.and_return({:view => "list"})
    @base.collection {}
    @base.collection(:view => "list") {}
    @base.collection.view.should == "list"
  end
  
  specify "should fail if no collection has been specified" do
    lambda { @base.collection }.should_raise
  end
end


