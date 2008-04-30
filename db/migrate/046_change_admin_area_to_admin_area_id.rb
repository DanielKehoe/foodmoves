class ChangeAdminAreaToAdminAreaId < ActiveRecord::Migration
  def self.up
		rename_column :addresses, :admin_area, :admin_area_id
  end

  def self.down
		rename_column :addresses, :admin_area_id, :admin_area
  end
end
