require File.dirname(__FILE__) + '/../../spec_helper'

context "/foods/index.rhtml" do
  include FoodsHelper
  
  setup do
    food_98 = mock("food_98")
    food_98.stub!(:to_param).and_return("98")
    food_98.should_receive(:parent_id).and_return("1")
    food_98.should_receive(:children_count).and_return("1")
    food_98.should_receive(:name).and_return("MyString")
    food_98.should_receive(:plu).and_return("1")
    food_98.should_receive(:form).and_return("1")

    food_99 = mock("food_99")
    food_99.stub!(:to_param).and_return("99")
    food_99.should_receive(:parent_id).and_return("1")
    food_99.should_receive(:children_count).and_return("1")
    food_99.should_receive(:name).and_return("MyString")
    food_99.should_receive(:plu).and_return("1")
    food_99.should_receive(:form).and_return("1")

    assigns[:foods] = [food_98, food_99]
  end

  specify "should render list of foods" do
    render "/foods/index.rhtml"

    response.should_have_tag 'td', :content => "1"
    response.should_have_tag 'td', :content => "MyString"
    response.should_have_tag 'td', :content => "1"
    response.should_have_tag 'td', :content => "1"
  end
end

