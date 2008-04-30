# == Schema Information
# Schema version: 111
#
# Table name: tag_for_locations
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   
#  sort_order :decimal(8, 2) 
#  of_type    :string(255)   
#

class TagForLocation < ActiveRecord::Base
  # base class, subclassed by TagForPhone and TagForAddress for single-table inheritance
  
  # support for single-table inheritance 
  # (use "of_type" to avoid conflict with reserved word "type")
  set_inheritance_column :of_type
  
  # sometimes we need a list of all the types of LocationTags
  def self.tag_types
    ['TagForPhone', 'TagForAddress']
  end
end
