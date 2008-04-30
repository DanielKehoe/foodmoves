class ChangeDefaultsInAuctionTable < ActiveRecord::Migration
  def self.up
		change_column :auctions, :how_many_bids, :integer, :default => 0
		change_column :auctions, :closed, :boolean, :default => 0
  end

  def self.down
		change_column :auctions, :how_many_bids, :integer, :default => nil
		change_column :auctions, :closed, :boolean, :default => nil
  end
end

