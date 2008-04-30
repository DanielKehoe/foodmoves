class AddSpanishNamesToFoodAttributes < ActiveRecord::Migration
  def self.up
    add_column :certifications, :en_espanol, :string
    add_column :colors, :en_espanol, :string
    add_column :conditions, :en_espanol, :string
    add_column :growns, :en_espanol, :string
    add_column :packs, :en_espanol, :string
    add_column :per_cases, :en_espanol, :string
    add_column :qualities, :en_espanol, :string
    add_column :sizes, :en_espanol, :string
    add_column :treatments, :en_espanol, :string
    add_column :weights, :en_espanol, :string
  end

  def self.down
    remove_column :certifications, :en_espanol
    remove_column :colors, :en_espanol
    remove_column :conditions, :en_espanol
    remove_column :growns, :en_espanol
    remove_column :packs, :en_espanol
    remove_column :per_cases, :en_espanol
    remove_column :qualities, :en_espanol
    remove_column :sizes, :en_espanol
    remove_column :treatments, :en_espanol
    remove_column :weights, :en_espanol
  end
end

