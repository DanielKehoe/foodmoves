class AddMoreToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :paca_license, :string, :limit	=> 30, :default => nil
    add_column :organizations, :bluebook_password, :string, :limit	=> 30, :default => nil
    add_column :organizations, :feedback_id, :integer, :default => nil
    add_column :organizations, :creditworth_id, :integer, :default => nil
    add_column :organizations, :timeliness_id, :integer, :default => nil
    add_column :organizations, :integrity_id, :integer, :default => nil
  end

  def self.down
    remove_column :organizations, :paca_license
    remove_column :organizations, :bluebook_password
    remove_column :organizations, :feedback_id
    remove_column :organizations, :creditworth_id
    remove_column :organizations, :timeliness_id
    remove_column :organizations, :integrity_id
  end
end
