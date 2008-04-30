class AddRegionIdToAddressTable < ActiveRecord::Migration
  def self.up
    remove_column :addresses, :region
    remove_column :addresses, :country
		add_column :addresses, :region_id, :integer
		add_column :addresses, :country_id, :integer
  end

  def self.down
    add_column :addresses, :region, :string
    add_column :addresses, :country, :string
		remove_column :addresses, :region_id
		remove_column :addresses, :country_id
  end
end