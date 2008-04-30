class CreatePackOptions < ActiveRecord::Migration
  def self.up
    create_table :pack_options do |t|
      t.column :food_id, :integer
      t.column :pack_id, :integer
    end
  end

  def self.down
    drop_table :pack_options
  end
end
