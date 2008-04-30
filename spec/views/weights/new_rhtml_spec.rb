require File.dirname(__FILE__) + '/../../spec_helper'

context "/weights/new.rhtml" do
  include WeightsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @weight = mock("weight")
    @weight.stub!(:to_param).and_return("99")
    @weight.stub!(:errors).and_return(@errors)
    @weight.stub!(:name).and_return("MyString")

    assigns[:weight] = @weight
  end

  specify "should render new form" do
    render "/weights/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => weights_path, :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'weight[name]'}
  end
end


