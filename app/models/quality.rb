# == Schema Information
# Schema version: 111
#
# Table name: qualities
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   
#  sort_order :decimal(8, 2) 
#  en_espanol :string(255)   
#

class Quality < ActiveRecord::Base
  has_one :auction
end
