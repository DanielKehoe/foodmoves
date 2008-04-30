class CreatePhones < ActiveRecord::Migration
  def self.up
   
    create_table :phones do |t|
      t.column :number, :string
      t.column :country_code, :string
      t.column :locality_code, :string
      t.column :local_number, :string
      t.column :location, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
    create_table :callables do |t|
      t.column :phone_id, :integer, :null => false
      t.column :phonerecord_id, :integer, :null => false
      t.column :phonerecord_type, :string, :null => false
    end
    
    add_index :callables, [:phone_id, :phonerecord_id, :phonerecord_type], 
      :unique => true, :name => 'index_callables' 
    
  end

  def self.down
    drop_table :callables
    drop_table :phones
  end
end
