class CreateContactsTable < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.column :first_name, :string, :limit	=> 80    
      t.column :last_name, :string, :limit	=> 80 
      t.column :email, :string, :limit	=> 80 
      t.column :time_zone, :string, :limit	=> 80, :default => 'Etc/UTC' 
      t.column :region_id, :integer
      t.column :country_id, :integer   
      t.column :industry_role, :string, :limit	=> 80    
      t.column :starts_as, :string, :limit	=> 80  
      t.column :created_by, :string, :limit	=> 80 # "Claudia Ramirez"
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :contacts
  end
end
