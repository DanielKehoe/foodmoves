# == Schema Information
# Schema version: 111
#
# Table name: watched_products
#
#  id          :integer(11)   not null, primary key
#  user_id     :integer(11)   
#  description :string(255)   
#  created_at  :datetime      
#  updated_at  :datetime      
#

class WatchedProduct < ActiveRecord::Base
  belongs_to :user
  
  # virtual attributes
  attr_accessor :auctions, :bids, :low, :high
  
  # make the object sortable by creation date
  def <=>(other_item)
    self.created_at <=> other_item.created_at
  end
 
end
