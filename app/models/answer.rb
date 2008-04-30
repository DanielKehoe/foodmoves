# == Schema Information
# Schema version: 111
#
# Table name: answers
#
#  id         :integer(11)   not null, primary key
#  sort_order :decimal(8, 2) default(50.0)
#  user_id    :integer(11)   
#  created_by :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#  topic      :string(255)   
#  question   :string(255)   
#  answer     :text          
#  approved   :boolean(1)    
#

class Answer < ActiveRecord::Base
end
