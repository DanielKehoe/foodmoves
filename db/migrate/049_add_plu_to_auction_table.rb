class AddPluToAuctionTable < ActiveRecord::Migration
  def self.up
    add_column :auctions, :plu, :integer
  end

  def self.down
    remove_column :auctions, :plu
  end
end
