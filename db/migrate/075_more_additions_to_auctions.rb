class MoreAdditionsToAuctions < ActiveRecord::Migration
  def self.up
    add_column :auctions, :test_only, :boolean
    add_column :auctions, :organic, :boolean
    add_column :auctions, :fair_trade, :boolean
    add_column :auctions, :pickup_number, :string
    add_column :treatments, :sort_order, :integer
    create_table :auctions_treatments, :id => false do |t|
      t.column :auction_id, :integer, :null => false
      t.column :treatment_id, :integer, :null => false
    end

  end

  def self.down
    remove_column :auctions, :test_only
    remove_column :auctions, :organic
    remove_column :auctions, :fair_trade
    remove_column :auctions, :pickup_number
    remove_column :treatments, :sort_order
    drop_table :auctions_treatments
  end
end
