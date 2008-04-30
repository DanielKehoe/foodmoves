class CreateWatchedProducts < ActiveRecord::Migration
  def self.up
    create_table :watched_products do |t|
      t.column :user_id, :integer
      t.column :description, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :watched_products
  end
end
