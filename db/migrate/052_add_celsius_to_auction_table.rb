class AddCelsiusToAuctionTable < ActiveRecord::Migration
  def self.up
    add_column :auctions, :celsius, :boolean
    add_column :auctions, :barcoded, :boolean
  end

  def self.down
    remove_column :auctions, :celsius
    remove_column :auctions, :barcoded
  end
end
