class CreateSizeOptions < ActiveRecord::Migration
  def self.up
    create_table :size_options do |t|
      t.column :food_id, :integer
      t.column :size_id, :integer
    end
  end

  def self.down
    drop_table :size_options
  end
end
