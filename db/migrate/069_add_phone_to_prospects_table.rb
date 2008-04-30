class AddPhoneToProspectsTable < ActiveRecord::Migration
  def self.up
    add_column :prospects, :country_code, :string
    add_column :prospects, :locality_code, :string
    add_column :prospects, :local_number, :string
  end

  def self.down
    remove_column :prospects, :country_code
    remove_column :prospects, :locality_code
    remove_column :prospects, :local_number
  end
end