class ChangeStringToIntegerForAdminArea < ActiveRecord::Migration
  def self.up
		change_column :addresses, :admin_area_id, :integer
  end

  def self.down
		change_column :addresses, :admin_area_id, :string
  end
end

