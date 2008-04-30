class ChangePhonesAndAddresses < ActiveRecord::Migration
  def self.up
    drop_table :callables
    drop_table :phones
    drop_table :addressables
    drop_table :addresses

    create_table :phones do |t|
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :phonable_id, :integer, :null => false
      t.column :phonable_type, :string, :null => false
      t.column :tag_for_phone, :string # could be "work phone", "home phone", etc
      t.column :number, :string # redundant but makes searching easier
      t.column :country_code, :string
      t.column :locality_code, :string # in the US, "area code", elsewhere "city code"
      t.column :local_number, :string
    end

    create_table :addresses do |t|
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :addressable_id, :integer, :null => false
      t.column :addressable_type, :string, :null => false
      t.column :tag_for_address, :string # could be "mailing address", "shipping address", etc
      t.column :lat, :string, :limit => 20
      t.column :lng, :string, :limit => 20
      t.column :region, :string
      t.column :country, :string
      t.column :admin_area, :string # in the US, "state"
      t.column :locality, :string # in the US, "city"
      t.column :thoroughfare, :string # in the US, "address"
      t.column :postal_code, :string
    end

    add_index :phones, :number 
    add_index :addresses, :thoroughfare 

  end

  def self.down
    drop_table :phones
    drop_table :addresses
  end
end
