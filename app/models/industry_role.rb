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

class IndustryRole < SurveyQuestion
end
