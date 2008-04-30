require File.dirname(__FILE__) + '/../spec_helper'
require 'roar/form'
require 'roar/action'
require 'roar/actions'

context "A blank form" do
  specify "should have two actions (save and delete)" do
    Roar::Form.new(mock('person')).actions.entries.size.should == 2
  end
  
  specify "should have an action named save" do
    Roar::Form.new(mock('person')).actions.entries.first.name.should == "Save"
  end
  
  specify "should have an action named delete" do
    Roar::Form.new(mock('person')).actions.entries.last.name.should == "Destroy"
  end

  specify "should have actions acting as enumerable" do
    Roar::Form.new(mock('person')).actions.each {|a| a.name }    
  end  
end

context "A form with preset actions" do  
  specify "should have a single action named save when given save_and_add_another" do
    form = Roar::Form.new(mock('person')) {
      actions do
        save_and_add_another
      end
    }
    form.actions.entries.first.name.should == "Save and add another"
    form.actions.entries.size.should == 1
  end
  
  specify "should allow a custom name" do
    Roar::Form.new(mock('person')) {
      actions { save_and_add_another :name=>"Save & Add" }
    }.actions.entries.first.name.should == "Save & Add"
  end
  
  specify "should have multiple actions specified" do
    form = Roar::Form.new(mock('person')) {
      actions {
        save
        save_and_continue_editing
      }
    }
    form.actions.entries.size.should == 2
    form.actions.entries.last.name.should == "Save and continue editing"
  end
  
  specify "should allow simple actions to be specified via a list" do
    form = Roar::Form.new(mock('person')) {
      actions [:save, :save_and_continue_editing]
    }
    form.actions.entries.size.should == 2
    form.actions.entries.last.name.should == "Save and continue editing"
  end
  
end
  
context "An action setup with three preset actions" do
  setup do
    @actions = Roar::Actions.new([:save, :save_and_continue_editing, :save_and_add_another])
  end
  
  specify "should return the correct action based on the name parameter" do
    @actions.active("Save and continue editing").should == :save_and_continue_editing
  end  
end
  
