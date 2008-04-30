class DropJoinModelsAndCreateHabtm < ActiveRecord::Migration
  def self.up

    drop_table :grown_options
    create_table :foods_growns, :id => false do |t|
      t.column :food_id, :integer, :null => false
      t.column :grown_id, :integer, :null => false
    end
    drop_table :pack_options
    create_table :foods_packs, :id => false do |t|
      t.column :food_id, :integer, :null => false
      t.column :pack_id, :integer, :null => false
    end
    drop_table :size_options
    create_table :foods_sizes, :id => false do |t|
      t.column :food_id, :integer, :null => false
      t.column :size_id, :integer, :null => false
    end
    drop_table :per_case_options
    create_table :foods_per_cases, :id => false do |t|
      t.column :food_id, :integer, :null => false
      t.column :per_case_id, :integer, :null => false
    end
    drop_table :weight_options
    create_table :foods_weights, :id => false do |t|
      t.column :food_id, :integer, :null => false
      t.column :weight_id, :integer, :null => false
    end
    drop_table :color_options
    create_table :colors_foods, :id => false do |t|
      t.column :food_id, :integer, :null => false
      t.column :color_id, :integer, :null => false
    end 
  end

  def self.down
    drop_table :foods_growns
    create_table :grown_options do |t|
      t.column :food_id, :integer
      t.column :grown_id, :integer
    end
    drop_table :foods_packs
    create_table :pack_options do |t|
      t.column :food_id, :integer
      t.column :pack_id, :integer
    end
    drop_table :foods_sizes
    create_table :size_options do |t|
      t.column :food_id, :integer
      t.column :size_id, :integer
    end
    drop_table :foods_per_cases
    create_table :per_case_options do |t|
      t.column :food_id, :integer
      t.column :per_case_id, :integer
    end
    drop_table :foods_weights
    create_table :weight_options do |t|
      t.column :food_id, :integer
      t.column :weight_id, :integer
    end
    drop_table :colors_foods
    create_table :color_options do |t|
      t.column :food_id, :integer
      t.column :color_id, :integer
    end
  end
end
