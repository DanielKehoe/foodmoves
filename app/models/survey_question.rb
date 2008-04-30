# == Schema Information
# Schema version: 111
#
# Table name: survey_questions
#
#  id          :integer(11)   not null, primary key
#  of_type     :string(255)   
#  sort_order  :decimal(8, 2) 
#  answer      :string(255)   
#  responses   :integer(11)   
#  description :string(255)   
#

class SurveyQuestion < ActiveRecord::Base
  
  # support for single-table inheritance (use "of_type" to avoid conflict with reserved word "type")
  set_inheritance_column :of_type
  
  # sometimes we need a list of all the subclasses
  def self.question_types
    ['IndustryRole']
  end
  
end
