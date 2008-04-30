class AddIcedToAuctions < ActiveRecord::Migration
  def self.up
    add_column :auctions, :iced, :boolean, :default => false
  end

  def self.down
    remove_column :auctions, :iced
  end
end
