class CreatePerCaseOptions < ActiveRecord::Migration
  def self.up
    create_table :per_case_options do |t|
      t.column :food_id, :integer
      t.column :per_case_id, :integer
    end
  end

  def self.down
    drop_table :per_case_options
  end
end
