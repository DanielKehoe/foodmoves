class AddFoodIdToWatchedProducts < ActiveRecord::Migration
  def self.up
    add_column :watched_products, :food_id, :integer
  end

  def self.down
    remove_column :watched_products, :food_id
  end
end
