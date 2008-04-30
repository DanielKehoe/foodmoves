class CreateProspectsTable < ActiveRecord::Migration
  def self.up
    create_table :prospects do |t|
      t.column :name, :string, :limit	=> 80 # "3 Rivers Potato Service, Inc."
      t.column :industry_role, :string, :limit	=> 80 # "shipper/distributor"
      t.column :locality, :string, :limit	=> 80 # "PASCO"
      t.column :admin_area_id, :integer # "WASHINGTON"
      t.column :country_id, :integer # "USA"
      t.column :admin_area_name, :integer # "WASHINGTON"
      t.column :country_name, :integer # "USA"
      t.column :region_id, :integer # "North America"
      t.column :mail_address, :string, :limit	=> 80 # "P.O. BOX 2791"
      t.column :mail_locality, :string, :limit	=> 80 # "Pasco"
      t.column :mail_admin_area_id, :integer # "WA"
      t.column :mail_country_id, :integer # "USA"
      t.column :mail_admin_area_name, :integer # "WASHINGTON"
      t.column :mail_country_name, :integer # "USA"
      t.column :mail_region_id, :integer # "North America"
      t.column :mail_postal_code, :string, :limit	=> 10 # "99302"
      t.column :phys_address, :string, :limit	=> 80 # "1911 SELPH LANDING RD."
      t.column :phys_locality, :string, :limit	=> 80 #  "Pasco"
      t.column :phys_admin_area_id, :integer # "WA"
      t.column :phys_country_id, :integer # "USA"
      t.column :phys_admin_area_name, :integer # "WASHINGTON"
      t.column :phys_country_name, :integer # "USA"
      t.column :phys_region_id, :integer # "North America"
      t.column :phys_postal_code, :string, :limit	=> 10 # "99301"
      t.column :phone, :string, :limit	=> 30 # "509 547-8488"
      t.column :email, :string, :limit	=> 80 # 
      t.column :website, :string, :limit	=> 80 # 
      t.column :source, :string, :limit	=> 34, :default => "other" # "bluebook"
      t.column :bluebook_member_id, :integer, :limit	=> 6 # "113291"
      t.column :created_by, :integer # "Claudia Ramirez"
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :prospects
  end
end
