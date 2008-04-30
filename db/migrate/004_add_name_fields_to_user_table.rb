class AddNameFieldsToUserTable < ActiveRecord::Migration
  def self.up
		add_column :users, :referred_by, :string
		add_column :users, :referred_by_id, :integer
		add_column :users, :invitation_code, :string
		add_column :users, :first_name, :string
		add_column :users, :last_name, :string
		add_column :users, :postal_code, :string
		add_column :users, :country, :string
		add_column :users, :state, :string
		add_column :users, :city, :string
		
  end

  def self.down
		remove_column :users, :referred_by
		remove_column :users, :referred_by_id
		remove_column :users, :invitation_code
		remove_column :users, :first_name
		remove_column :users, :last_name
		remove_column :users, :postal_code
		remove_column :users, :country
		remove_column :users, :state
		remove_column :users, :city
  end
end
