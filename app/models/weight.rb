# == Schema Information
# Schema version: 111
#
# Table name: weights
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   default(""), not null
#  sort_order :decimal(8, 2) 
#  en_espanol :string(255)   
#

class Weight < ActiveRecord::Base
  has_and_belongs_to_many :foods
  has_one :auction
end
