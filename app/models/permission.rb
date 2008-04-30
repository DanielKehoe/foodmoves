# == Schema Information
# Schema version: 111
#
# Table name: permissions
#
#  id         :integer(11)   not null, primary key
#  user_id    :integer(11)   
#  role_id    :integer(11)   
#  created_at :datetime      
#  updated_at :datetime      
#

class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
end
