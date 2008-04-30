class AddFieldsToProspects < ActiveRecord::Migration
  def self.up
    add_column :prospects, :person, :string
    add_column :prospects, :thoroughfare, :string
    add_column :prospects, :postal_code, :string
    add_column :prospects, :phone, :string
  end

  def self.down
    remove_column :prospects, :person
    remove_column :prospects, :thoroughfare
    remove_column :prospects, :postal_code
    remove_column :prospects, :phone
  end
end