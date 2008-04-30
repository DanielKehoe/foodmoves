require File.dirname(__FILE__) + '/../../spec_helper'

context "/foods/show.rhtml" do
  include FoodsHelper
  
  setup do
    @food = mock("food")
    @food.stub!(:to_param).and_return("99")
    @food.stub!(:errors).and_return(@errors)
    @food.stub!(:parent_id).and_return("1")
    @food.stub!(:children_count).and_return("1")
    @food.stub!(:name).and_return("MyString")
    @food.stub!(:plu).and_return("1")
    @food.stub!(:form).and_return("1")

    assigns[:food] = @food
  end

  specify "should render attributes in <p>" do
    render "/foods/show.rhtml"

    # response.should_have_tag('p', :content => "1")
    # response.should_have_tag('p', :content => "MyString")
    # response.should_have_tag('p', :content => "1")
    # response.should_have_tag('p', :content => "1")
  end
end

