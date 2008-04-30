require File.dirname(__FILE__) + '/../spec_helper'

context "A blank Roar::Base" do
  setup do
    class News
      def self.table_name 
        return "news"
      end
    end
    @controller = mock('controller')
    @controller.stub!(:params).and_return({})
    @controller.stub!(:model_class).and_return(News)
    @base = Roar::Base.new(@controller)
  end
  
  specify "should have a default per_page value" do
    @base.collection_options[:per_page].should == 10
  end
  
  specify "should have a blank default value for order" do
    @base.collection_options[:order].should == ''
  end
  
  specify "should use the default view" do
    @base.view.should == "default"
  end
  
  specify "should have a blank value for include" do
    @base.collection_options[:include].should == ""
  end
  
  

  specify "should not have any filters defined" do
    @base.filters.query.conditions.should == nil
  end
end

context "A Simple Roar::Base" do
  setup do
    @base = Roar::Base.new(mock('controller')) do
      per_page 20
      order "updated_at DESC"
      include "test"
    end
  end
  
  specify "should set per_page value" do
    @base.collection_options[:per_page].should == 20
  end
  
  specify "should set a value for order" do
    @base.collection_options[:order].should == "updated_at DESC"
  end  
  
  specify "should set a value for include" do
    @base.collection_options[:include].should == "test"
  end
  
  
end



context "An Base with a filter" do
  setup do
    class News
    end
    News.stub!(:collection_name).and_return("news")
    News.stub!(:reflect_on_association).and_return(nil)
    News.stub!(:column_methods_hash).and_return({:title=>"title"})
    @controller = mock('controller')
    @controller.stub!(:model_class).and_return(News)
  end
  
  specify "should have one filter specified" do
    @controller.stub!(:params).and_return({:text=>"hey"})
    @base = Roar::Base.new(@controller) {
      filters { search :text, :fields => :title }
    }
    @base.filters.query.conditions.should == \
      " (   (  ( news.title LIKE ? )  )   ) "
  end
  
  specify "should not define filter when params are empty" do
    @controller.stub!(:params).and_return({})
    @base = Roar::Base.new(@controller)  {
      filters { search :text, :fields => :title }
    }
    @base.filters.query.conditions.should == nil
  end
  
  specify "should specify filters one at a time" do
    @controller.stub!(:params).and_return({:text=>"hey"})
    @base = Roar::Base.new(@controller) {
      filter :search, :text, :fields => :title 
    }
    @base.filters.query.conditions.should == \
      " (   (  ( news.title LIKE ? )  )   ) "
  end
  
  
end
  
context "A Basic Base with the simplest possible collection and form" do
  setup do
    class News
    end
    News.stub!(:collection_name).and_return("news")
    News.stub!(:reflect_on_association).and_return(nil)
    News.stub!(:column_methods_hash).and_return({:title=>"title"})
    @controller = mock('controller')
    @controller.stub!(:model_symbol).and_return(:news)
    @controller.stub!(:params).and_return({})
    @base = Roar::Base.new(@controller) {
      collection {
        column :title
      }
      form {
        text_field :title
      }
    }
  end
  
  specify "should have a collection with one column" do
    @base.collection.columns.size.should == 1
  end
  
  specify "should have a form with one field" do
    #fixme
    #@base.form.fields.size.should == 1
  end
    
end