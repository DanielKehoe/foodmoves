# == Schema Information
# Schema version: 111
#
# Table name: integrity
#
#  id          :integer(11)   not null, primary key
#  sort_order  :integer(11)   
#  description :string(255)   
#

class Integrity < ActiveRecord::Base
  set_table_name 'integrity'
  has_many :auctions
  has_many :organizations
end
