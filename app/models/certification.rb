# == Schema Information
# Schema version: 111
#
# Table name: certifications
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   
#  url        :string(255)   
#  sort_order :decimal(8, 2) 
#  en_espanol :string(255)   
#

class Certification < ActiveRecord::Base
  
  has_and_belongs_to_many :auctions
  
end
