class AddBuyNowToAuction < ActiveRecord::Migration
  def self.up
    add_column :auctions, :buy_now_price, :decimal, :precision => 10, :scale => 2, :default => 0 
  end

  def self.down
    remove_column :auctions, :buy_now_price
  end
end
