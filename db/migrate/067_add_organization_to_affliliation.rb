class AddOrganizationToAffliliation < ActiveRecord::Migration
  def self.up
    add_column :affiliations, :organization_id, :integer
    remove_column :affiliations, :bluebook_member_id
  end

  def self.down
    remove_column :affiliations, :organization_id
    add_column :affiliations, :bluebook_member_id, :integer, :limit	=> 6 # "113291"
  end
end