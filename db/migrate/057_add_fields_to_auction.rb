class AddFieldsToAuction < ActiveRecord::Migration
  def self.up
    add_column :auctions, :lot_number, :string
    add_column :auctions, :pickup_limit, :integer
    add_column :auctions, :cases_per_pallet, :integer
    add_column :auctions, :pallets, :integer
    create_table :treatments do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :treatments
    remove_column :auctions, :lot_number
    remove_column :auctions, :pickup_limit
    remove_column :auctions, :cases_per_pallet
    remove_column :auctions, :pallets
  end
end
