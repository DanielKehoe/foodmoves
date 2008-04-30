class AddOfTypeToProspects < ActiveRecord::Migration
  def self.up
    add_column :prospects, :of_type, :string, :default => 'Prospect'
    change_column :organizations, :of_type, :string, :default => 'Organization'
  end

  def self.down
    remove_column :prospects, :of_type
    change_column :organizations, :of_type, :string, :default => nil
  end
end