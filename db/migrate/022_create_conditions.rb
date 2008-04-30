class CreateConditions < ActiveRecord::Migration
  def self.up
    create_table :conditions do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :conditions
  end
end
