class AddCreatedByIdToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :created_by_id, :integer
  end

  def self.down
    remove_column :assets, :created_by_id
  end
end
