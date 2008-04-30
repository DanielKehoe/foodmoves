class CreateGrowns < ActiveRecord::Migration
  def self.up
    create_table :growns do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :growns
  end
end
