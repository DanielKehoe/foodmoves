class CreateFoods < ActiveRecord::Migration
  def self.up
    create_table :foods do |t|
      t.column :parent_id, :integer
      t.column :children_count, :integer
      t.column :name, :string
      t.column :plu, :integer
      t.column :form, :decimal, :precision => 8, :scale => 2
    end
  end

  def self.down
    drop_table :foods
  end
end
