class UserLoginBecomesType < ActiveRecord::Migration
  def self.up
		rename_column :users, :login, :of_type
  end

  def self.down
		rename_column :users, :of_type, :login
  end
end
