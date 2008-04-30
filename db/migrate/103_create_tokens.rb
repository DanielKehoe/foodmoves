class CreateTokens < ActiveRecord::Migration
  def self.up
    create_table :tokens do |t|
      t.column :tag, :string
      t.column :encrypted, :string
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :month, :string
      t.column :year, :string
      t.column :region, :string
      t.column :country, :string
      t.column :admin_area, :string
      t.column :locality, :string
      t.column :thoroughfare, :string
      t.column :postal_code, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :tokens
  end
end
