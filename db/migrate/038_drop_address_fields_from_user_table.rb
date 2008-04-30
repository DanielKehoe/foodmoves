class DropAddressFieldsFromUserTable < ActiveRecord::Migration
  def self.up
    remove_column :users, :postal_code
		remove_column :users, :state
		remove_column :users, :city
  end

  def self.down
    add_column :users, :postal_code, :string
		add_column :users, :state, :string
		add_column :users, :city, :string
  end
end
