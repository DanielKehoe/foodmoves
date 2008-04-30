class CreatePerCases < ActiveRecord::Migration
  def self.up
    create_table :per_cases do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :per_cases
  end
end
