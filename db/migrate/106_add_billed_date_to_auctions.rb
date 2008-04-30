class AddBilledDateToAuctions < ActiveRecord::Migration
  def self.up
    add_column :auctions, :date_billed, :datetime
  end

  def self.down
    remove_column :auctions, :date_billed
  end
end
