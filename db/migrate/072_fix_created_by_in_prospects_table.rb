class FixCreatedByInProspectsTable < ActiveRecord::Migration
  def self.up
    change_column :prospects, :created_by, :string
  end

  def self.down
    change_column :prospects, :created_by, :integer
  end
end