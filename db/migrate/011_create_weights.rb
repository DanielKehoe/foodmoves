class CreateWeights < ActiveRecord::Migration
  def self.up
    create_table :weights do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :weights
  end
end
