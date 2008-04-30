class CreateWeightOptions < ActiveRecord::Migration
  def self.up
    create_table :weight_options do |t|
      t.column :food_id, :integer
      t.column :weight_id, :integer
    end
  end

  def self.down
    drop_table :weight_options
  end
end
