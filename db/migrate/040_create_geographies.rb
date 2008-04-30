class CreateGeographies < ActiveRecord::Migration
  def self.up
    create_table :geographies do |t|
  		t.column :parent_id, :integer
  		t.column :children_count, :integer
  		t.column :sort_order, :decimal, :precision => 8, :scale => 2
  		t.column :place, :boolean
  		t.column :of_type, :string
  		t.column :label, :string
  		t.column :lat, :decimal, :precision => 15, :scale => 10 # latitude
      t.column :lng, :decimal, :precision => 15, :scale => 10 # longitude
      t.column :name, :string # common name
      t.column :code, :string # IANA top-level domain (countries) postal abbreviation (for states)
      t.column :three_letter_code, :string # ISO 3166-1 3 Letter Country Code
      t.column :three_digit_code, :string # ISO 3166-1 Country Number
      t.column :phone_code, :string # ITU-T Telephone Country Code
      t.column :currency_code, :string # ISO 4217 Currency Code
      t.column :currency_name, :string # ISO 4217 Currency Name
      t.column :admin_by_id, :integer
    end
  end

  def self.down
    drop_table :geographies
  end
end
