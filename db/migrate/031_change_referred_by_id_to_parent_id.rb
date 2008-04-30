class ChangeReferredByIdToParentId < ActiveRecord::Migration
  def self.up
		rename_column :users, :referred_by_id, :parent_id
		add_column :users, :children_count, :integer
  end

  def self.down
		rename_column :users, :parent_id, :referred_by_id
		remove_column :users, :children_count
  end
end