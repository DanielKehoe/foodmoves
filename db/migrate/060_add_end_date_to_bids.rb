class AddEndDateToBids < ActiveRecord::Migration
  def self.up
    add_column :bids, :date_to_end, :datetime
  end

  def self.down
    remove_column :bids, :date_to_end
  end
end

