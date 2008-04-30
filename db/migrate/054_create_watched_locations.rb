class CreateWatchedLocations < ActiveRecord::Migration
  def self.up
    create_table :watched_locations do |t|
      t.column :user_id, :string
      t.column :name, :string
      t.column :locality, :string
      t.column :admin_area_id, :integer
      t.column :country_id, :integer
      t.column :region_id, :integer
      t.column :lat, :decimal, :precision => 15, :scale => 10, :default => 0
      t.column :lng, :decimal, :precision => 15, :scale => 10, :default => 0
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :watched_locations
  end
end
