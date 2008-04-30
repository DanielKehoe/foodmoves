class MergeProspectsWithOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :of_type, :string
    add_column :organizations, :locality, :string, :limit	=> 80 # "MOBILE"
    add_column :organizations, :admin_area_id, :integer # "ALABAMA = 264"
    add_column :organizations, :country_id, :integer # "USA = 239"
    add_column :organizations, :admin_area_abbr, :string # "AL"
    add_column :organizations, :country_name, :string # "USA"
    add_column :organizations, :region_id, :integer # "North America = 9"
    add_column :organizations, :email, :string, :limit	=> 80 
    add_column :organizations, :website, :string, :limit	=> 80 
    add_column :organizations, :source, :string, :limit	=> 34, :default => "other" # "bluebook"
    add_column :organizations, :created_by_name, :string # "Claudia Ramirez"
    add_column :organizations, :lat, :decimal, :precision => 15, :scale => 10, :default => 0
    add_column :organizations, :lng, :decimal, :precision => 15, :scale => 10, :default => 0
    add_column :organizations, :person, :string
    add_column :organizations, :thoroughfare, :string
    add_column :organizations, :postal_code, :string
    add_column :organizations, :phone, :string
    add_column :organizations, :call_result, :string, :default => 'not called'
    add_column :organizations, :updated_by, :string, :default => nil
    add_column :organizations, :acct_exec_id, :integer
    rename_column :contacts, :prospect_id, :organization_id
  end

  def self.down
    rename_column :contacts, :organization_id, :prospect_id
    remove_column :organizations, :of_type
    remove_column :organizations, :locality
    remove_column :organizations, :admin_area_id
    remove_column :organizations, :country_id
    remove_column :organizations, :admin_area_abbr
    remove_column :organizations, :country_name
    remove_column :organizations, :region_id
    remove_column :organizations, :email
    remove_column :organizations, :website
    remove_column :organizations, :source
    remove_column :organizations, :created_by_name
    remove_column :organizations, :lat
    remove_column :organizations, :lng
    remove_column :organizations, :person
    remove_column :organizations, :thoroughfare
    remove_column :organizations, :postal_code
    remove_column :organizations, :phone
    remove_column :organizations, :call_result
    remove_column :organizations, :updated_by
    remove_column :organizations, :acct_exec_id
  end
end
