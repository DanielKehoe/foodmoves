class AddRegionIdToUserTable < ActiveRecord::Migration
  def self.up
		add_column :users, :region_id, :integer
		add_column :users, :country_id, :integer
  end

  def self.down
		remove_column :users, :region_id
		remove_column :users, :country_id
  end
end
