# == Schema Information
# Schema version: 111
#
# Table name: liability_limits
#
#  id          :integer(11)   not null, primary key
#  sort_order  :decimal(8, 2) 
#  description :string(255)   
#

class LiabilityLimit < ActiveRecord::Base
  has_many :organizations
end
