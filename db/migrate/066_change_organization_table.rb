class ChangeOrganizationTable < ActiveRecord::Migration
  def self.up
    add_column :organizations, :rated_by, :string, :default => "other"
    add_column :organizations, :bluebook_member_id, :integer, :limit	=> 6 # "113291"
    add_column :organizations, :created_by, :integer
  end

  def self.down
    remove_column :organizations, :rated_by
    remove_column :organizations, :bluebook_member_id
    remove_column :organizations, :created_by
  end
end
