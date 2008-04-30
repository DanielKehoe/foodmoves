class CreateMugShots < ActiveRecord::Migration
  def self.up
    create_table :mug_shots do |t|
      t.column :parent_id, :integer
      t.column :content_type, :string
      t.column :filename, :string
      t.column :thumbnail, :string
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.column :created_by, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    add_column :users, :mug_shot_id, :integer
  end

  def self.down
    remove_column :users, :mug_shot_id
    drop_table :mug_shots
  end
end
