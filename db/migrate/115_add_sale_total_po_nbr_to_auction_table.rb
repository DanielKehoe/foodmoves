class AddSaleTotalPoNbrToAuctionTable < ActiveRecord::Migration
  def self.up
    add_column :auctions, :sale_total, :decimal, :precision => 10, :scale => 2, :default => 0 
    add_column :auctions, :po_number, :string
  end

  def self.down
    remove_column :auctions, :sale_total
    remove_column :auctions, :po_number
  end
end
