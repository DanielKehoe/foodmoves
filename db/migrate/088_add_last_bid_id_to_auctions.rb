class AddLastBidIdToAuctions < ActiveRecord::Migration
  def self.up
    add_column :auctions, :last_bid_id, :integer
  end

  def self.down
    remove_column :auctions, :last_bid_id
  end
end
