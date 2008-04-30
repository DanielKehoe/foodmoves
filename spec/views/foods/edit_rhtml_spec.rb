require File.dirname(__FILE__) + '/../../spec_helper'

context "/foods/edit.rhtml" do
  include FoodsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @food = mock_model(Food, :errors => @errors)
    @food.stub!(:parent_id).and_return("1")
    @food.stub!(:children_count).and_return("1")
    @food.stub!(:name).and_return("MyString")
    @food.stub!(:plu).and_return("1")
    @food.stub!(:form).and_return("1")

    assigns[:food] = @food
  end

  specify "should render edit form" do
    render "/foods/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => food_path(@food), :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'food[children_count]'}
    response.should_have_tag 'input', :attributes =>{:name => 'food[name]'}
    response.should_have_tag 'input', :attributes =>{:name => 'food[plu]'}
    response.should_have_tag 'input', :attributes =>{:name => 'food[form]'}
  end
end


