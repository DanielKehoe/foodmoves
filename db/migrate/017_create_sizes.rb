class CreateSizes < ActiveRecord::Migration
  def self.up
    create_table :sizes do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :sizes
  end
end
