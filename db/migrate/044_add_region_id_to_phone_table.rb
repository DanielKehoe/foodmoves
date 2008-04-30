class AddRegionIdToPhoneTable < ActiveRecord::Migration
  def self.up
		add_column :phones, :region_id, :integer
  end

  def self.down
		remove_column :phones, :region_id
  end
end
