# == Schema Information
# Schema version: 111
#
# Table name: buys
#
#  query         :string        
#  watch         :boolean       
#  location_id   :integer       
#  location_name :string        
#  show_map      :boolean       
#

class Buy < ActiveRecord::BaseWithoutTable
  # this model is not backed by a database table
  column :query, :string
  column :watch, :boolean
  column :location_id, :integer
  column :location_name, :string
  column :show_map, :boolean
  
  validates_presence_of :query
end
