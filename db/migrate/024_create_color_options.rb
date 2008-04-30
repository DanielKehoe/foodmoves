class CreateColorOptions < ActiveRecord::Migration
  def self.up
    create_table :color_options do |t|
      t.column :food_id, :integer
      t.column :color_id, :integer
    end
  end

  def self.down
    drop_table :color_options
  end
end
