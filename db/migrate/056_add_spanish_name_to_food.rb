class AddSpanishNameToFood < ActiveRecord::Migration
  def self.up
    add_column :foods, :en_espanol, :string
  end

  def self.down
    remove_column :foods, :en_espanol
  end
end

