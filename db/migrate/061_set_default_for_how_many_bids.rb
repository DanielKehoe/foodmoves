class SetDefaultForHowManyBids < ActiveRecord::Migration
  def self.up
		change_column :auctions, :how_many_bids, :integer, :default => 0
  end

  def self.down
		change_column :auctions, :how_many_bids, :integer
  end
end