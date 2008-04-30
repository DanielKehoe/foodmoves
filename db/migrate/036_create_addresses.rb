class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.column :tag_for_address, :string
      t.column :lat, :decimal, :precision => 15, :scale => 10, :default => 0
      t.column :lng, :decimal, :precision => 15, :scale => 10, :default => 0
      t.column :region, :string
      t.column :country, :string
      t.column :admin_area, :string
      t.column :locality, :string
      t.column :thoroughfare, :string
      t.column :postal_code, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end

    create_table :addressables do |t|
      t.column :address_id, :integer, :null => false
      t.column :addressrecord_id, :integer, :null => false
      t.column :addressrecord_type, :string, :null => false
    end

    add_index :addressables, [:address_id, :addressrecord_id, :addressrecord_type], 
      :unique => true, :name => 'index_addressables' 

  end

  def self.down
    drop_table :addressables
    drop_table :addresses
  end
end
