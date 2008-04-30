class AddKosherToAuctions < ActiveRecord::Migration
  def self.up
    add_column :auctions, :kosher, :boolean
  end

  def self.down
    remove_column :auctions, :kosher
  end
end
