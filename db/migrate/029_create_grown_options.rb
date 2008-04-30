class CreateGrownOptions < ActiveRecord::Migration
  def self.up
    create_table :grown_options do |t|
      t.column :food_id, :integer
      t.column :grown_id, :integer
    end
  end

  def self.down
    drop_table :grown_options
  end
end
