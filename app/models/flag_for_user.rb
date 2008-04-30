# == Schema Information
# Schema version: 111
#
# Table name: flag_for_users
#
#  id          :integer(11)   not null, primary key
#  name        :string(255)   
#  sort_order  :decimal(8, 2) 
#  color       :string(255)   
#  description :string(255)   
#

class FlagForUser < ActiveRecord::Base
  has_many :users
end
