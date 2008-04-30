class AddSortOrderToFoodOptionsTables < ActiveRecord::Migration
  def self.up
		add_column :certifications, :sort_order, :decimal, :precision => 8, :scale => 2
		add_column :colors, :sort_order, :decimal, :precision => 8, :scale => 2
		add_column :conditions, :sort_order, :decimal, :precision => 8, :scale => 2
		add_column :growns, :sort_order, :decimal, :precision => 8, :scale => 2
		add_column :packs, :sort_order, :decimal, :precision => 8, :scale => 2
		add_column :per_cases, :sort_order, :decimal, :precision => 8, :scale => 2
		add_column :qualities, :sort_order, :decimal, :precision => 8, :scale => 2
		add_column :sizes, :sort_order, :decimal, :precision => 8, :scale => 2
		add_column :weights, :sort_order, :decimal, :precision => 8, :scale => 2
  end

  def self.down
		remove_column :certifications, :sort_order
		remove_column :colors, :sort_order
		remove_column :conditions, :sort_order
		remove_column :growns, :sort_order
		remove_column :packs, :sort_order
		remove_column :per_cases, :sort_order
		remove_column :qualities, :sort_order
		remove_column :sizes, :sort_order
		remove_column :weights, :sort_order
  end
end
