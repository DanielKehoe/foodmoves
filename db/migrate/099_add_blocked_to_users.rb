class AddBlockedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :blocked, :boolean
    add_column :users, :do_not_contact, :boolean
    add_column :organizations, :do_not_contact, :boolean
  end

  def self.down
    remove_column :users, :blocked
    remove_column :users, :do_not_contact
    remove_column :organizations, :do_not_contact
  end
end

