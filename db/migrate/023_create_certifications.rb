class CreateCertifications < ActiveRecord::Migration
  def self.up
    create_table :certifications do |t|
      t.column :name, :string
      t.column :url, :string
    end
  end

  def self.down
    drop_table :certifications
  end
end
