class ChangeFormToSortOrderForFoods < ActiveRecord::Migration
  def self.up
		rename_column :foods, :form, :sort_order
  end

  def self.down
		rename_column :foods, :sort_order, :form
  end
end
