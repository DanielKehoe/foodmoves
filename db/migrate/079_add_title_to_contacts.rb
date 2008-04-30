class AddTitleToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :title, :string
  end

  def self.down
    remove_column :contacts, :title
  end
end