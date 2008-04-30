class AddUpdatedTimeToFoods < ActiveRecord::Migration
  def self.up
		add_column :foods, :created_at, :datetime
		add_column :foods, :updated_at, :datetime
		add_column :foods, :updated_by, :string
  end

  def self.down
		remove_column :foods, :created_at
		remove_column :foods, :updated_at
		remove_column :foods, :updated_by
  end
end
