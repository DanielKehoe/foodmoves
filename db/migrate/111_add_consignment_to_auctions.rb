class AddConsignmentToAuctions < ActiveRecord::Migration
  def self.up
    add_column :auctions, :consignment, :boolean, :default => false
  end

  def self.down
    remove_column :auctions, :consignment
  end
end
