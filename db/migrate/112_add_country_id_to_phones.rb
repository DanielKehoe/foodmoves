class AddCountryIdToPhones < ActiveRecord::Migration
  def self.up
		add_column :phones, :country_id, :integer
  end

  def self.down
		remove_column :phones, :country_id
  end
end
