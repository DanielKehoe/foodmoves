require File.dirname(__FILE__) + '/../../spec_helper'

context "/foods/new.rhtml" do
  include FoodsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

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

  specify "should render new form" do
    render "/foods/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => foods_path, :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'food[children_count]'}
    response.should_have_tag 'input', :attributes =>{:name => 'food[name]'}
    response.should_have_tag 'input', :attributes =>{:name => 'food[plu]'}
    response.should_have_tag 'input', :attributes =>{:name => 'food[form]'}
  end
end


