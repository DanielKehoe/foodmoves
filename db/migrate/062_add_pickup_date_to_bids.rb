class AddPickupDateToBids < ActiveRecord::Migration
  def self.up
    add_column :bids, :date_to_pickup, :datetime
  end

  def self.down
    remove_column :bids, :date_to_pickup
  end
end

