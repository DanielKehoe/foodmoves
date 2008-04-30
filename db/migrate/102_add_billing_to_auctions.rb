class AddBillingToAuctions < ActiveRecord::Migration
  def self.up
    add_column :auctions, :premium_service, :boolean, :default => false
    add_column :auctions, :bill_me, :boolean, :default => false
    add_column :auctions, :discount, :boolean, :default => false
    add_column :auctions, :due_foodmoves, :decimal, :precision => 10, :scale => 2, :default => 0
    add_column :auctions, :date_paid, :datetime
  end

  def self.down
    remove_column :auctions, :premium_service
    remove_column :auctions, :bill_me
    remove_column :auctions, :discount
    remove_column :auctions, :due_foodmoves
    remove_column :auctions, :date_paid
  end
end
