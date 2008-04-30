require File.dirname(__FILE__) + '/../spec_helper'
require 'roar/form'

context "A blank form" do
  specify "should have no fields" do
    Roar::Form.new(mock('person')).fields.should_be_empty
  end  
  
  specify "should use the default view" do
    Roar::Form.new(mock('person')).view.should == "default"
  end
end

context "A simple form" do
  setup do
    @form = Roar::Form.new(mock('person')) do
      text_field :title
    end
  end
  
  specify "should have one field" do
    @form.fields.size.should == 1
  end
end

  
context "Nested Forms" do
  class Person
  end
  
  setup do
    @person = mock('person')
    @person.stub!(:class).and_return(Person)
    @form = Roar::Form.new(@person) do
      text_field :title
      fields_for :contact_data do
        text_field :address
      end
    end
  end
  
  specify "should have nested fields" do
    @form.fields.size.should == 2
    @form.fields.last.method.should == :contact_data
    @form.fields.last.fields.size.should == 1
  end
  
  specify "should respond to path" do
    @form.path.should == "person"
    contact_field = @form.fields.last
    contact_field.add_path_segment("contact_data")
    @form.fields.last.path.should == "person[contact_data]"
  end
end

