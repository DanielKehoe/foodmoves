# == Schema Information
# Schema version: 111
#
# Table name: foods
#
#  id             :integer(11)   not null, primary key
#  parent_id      :integer(11)   
#  children_count :integer(11)   default(0), not null
#  name           :string(255)   default(""), not null
#  plu            :integer(11)   default(0)
#  sort_order     :decimal(8, 2) default(99.0)
#  en_espanol     :string(255)   
#  created_at     :datetime      
#  updated_at     :datetime      
#  updated_by     :string(255)   
#

class Food < ActiveRecord::Base
  acts_as_tree :order => "name", :counter_cache => :children_count, :order => 'sort_order, name'
  has_and_belongs_to_many :colors, :order => 'sort_order'
  has_and_belongs_to_many :weights, :order => 'sort_order'
  has_and_belongs_to_many :per_cases, :order => 'sort_order'
  has_and_belongs_to_many :sizes, :order => 'sort_order'
  has_and_belongs_to_many :packs, :order => 'sort_order'
  has_and_belongs_to_many :growns, :order => 'sort_order'
  
  def to_s
    name
  end
  
end
