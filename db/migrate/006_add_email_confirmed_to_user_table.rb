class AddEmailConfirmedToUserTable < ActiveRecord::Migration
  def self.up
		add_column :users, :email_confirmed, :boolean
  end

  def self.down
		remove_column :users, :email_confirmed
  end
end
