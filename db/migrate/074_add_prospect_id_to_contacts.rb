class AddProspectIdToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :prospect_id, :integer
  end

  def self.down
    remove_column :contacts, :created_by
  end
end
