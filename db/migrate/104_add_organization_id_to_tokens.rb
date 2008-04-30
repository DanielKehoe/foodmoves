class AddOrganizationIdToTokens < ActiveRecord::Migration
  def self.up
    add_column :tokens, :organization_id, :integer
  end

  def self.down
    remove_column :tokens, :organization_id
  end
end
