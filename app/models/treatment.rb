# == Schema Information
# Schema version: 111
#
# Table name: treatments
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   
#  en_espanol :string(255)   
#  sort_order :integer(11)   
#

class Treatment < ActiveRecord::Base

  has_and_belongs_to_many :auctions

end

