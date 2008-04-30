class ModifyProspectsTable < ActiveRecord::Migration
  def self.up
    add_column :prospects, :lat, :decimal, :precision => 15, :scale => 10, :default => 0
    add_column :prospects, :lng, :decimal, :precision => 15, :scale => 10, :default => 0
    rename_column :prospects, :admin_area_name, :admin_area_abbr
    rename_column :prospects, :mail_admin_area_name, :mail_admin_area_abbr
    rename_column :prospects, :phys_admin_area_name, :phys_admin_area_abbr
  end

  def self.down
    remove_column :prospects, :lat
    remove_column :prospects, :lng
    rename_column :prospects, :admin_area_abbr, :admin_area_name
    rename_column :prospects, :mail_admin_area_abbr, :mail_admin_area_name
    rename_column :prospects, :phys_admin_area_abbr, :phys_admin_area_name
  end
end