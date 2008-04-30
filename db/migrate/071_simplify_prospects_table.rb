class SimplifyProspectsTable < ActiveRecord::Migration
  def self.up
    change_column :prospects, :admin_area_abbr, :string
    change_column :prospects, :country_name, :string
    remove_column :prospects, :country_code
    remove_column :prospects, :locality_code
    remove_column :prospects, :local_number
    remove_column :prospects, :mail_admin_area_abbr
    remove_column :prospects, :phys_admin_area_abbr
    remove_column :prospects, :mail_address
    remove_column :prospects, :mail_locality
    remove_column :prospects, :mail_admin_area_id
    remove_column :prospects, :mail_country_id
    remove_column :prospects, :mail_country_name
    remove_column :prospects, :mail_region_id
    remove_column :prospects, :mail_postal_code
    remove_column :prospects, :phys_address
    remove_column :prospects, :phys_locality
    remove_column :prospects, :phys_admin_area_id
    remove_column :prospects, :phys_country_id
    remove_column :prospects, :phys_country_name
    remove_column :prospects, :phys_region_id
    remove_column :prospects, :phys_postal_code
    remove_column :prospects, :phone
    
  end

  def self.down
    change_column :prospects, :admin_area_abbr, :integer
    change_column :prospects, :country_name, :integer
    add_column :prospects, :country_code, :string
    add_column :prospects, :locality_code, :string
    add_column :prospects, :local_number, :string
    add_column :prospects, :mail_admin_area_abbr, :integer
    add_column :prospects, :phys_admin_area_abbr, :integer
    add_column :prospects, :mail_address, :string, :limit	=> 80 # "P.O. BOX 2791"
    add_column :prospects, :mail_locality, :string, :limit	=> 80 # "Pasco"
    add_column :prospects, :mail_admin_area_id, :integer # "WA"
    add_column :prospects, :mail_country_id, :integer # "USA"
    add_column :prospects, :mail_country_name, :integer # "USA"
    add_column :prospects, :mail_region_id, :integer # "North America"
    add_column :prospects, :mail_postal_code, :string, :limit	=> 10 # "99302"
    add_column :prospects, :phys_address, :string, :limit	=> 80 # "1911 SELPH LANDING RD."
    add_column :prospects, :phys_locality, :string, :limit	=> 80 #  "Pasco"
    add_column :prospects, :phys_admin_area_id, :integer # "WA"
    add_column :prospects, :phys_country_id, :integer # "USA"
    add_column :prospects, :phys_country_name, :integer # "USA"
    add_column :prospects, :phys_region_id, :integer # "North America"
    add_column :prospects, :phys_postal_code, :string, :limit	=> 10 # "99301"
    add_column :prospects, :phone, :string, :limit	=> 30 # "509 547-8488"
  end
end
