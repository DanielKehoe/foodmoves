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

class TagForPhone < TagForLocation
  # single-table inheritance from TagForLocation
end
