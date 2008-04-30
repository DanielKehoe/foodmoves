class CreateAffiliations < ActiveRecord::Migration
  def self.up
    create_table :affiliations do |t|
      t.column :user_id, :integer
      t.column :bluebook_member_id, :integer, :limit	=> 6 # "113291"
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :approved, :boolean, :default => 0
      t.column :reviewed_at, :datetime
      t.column :called_by, :string, :limit	=> 80 
      t.column :talked_to, :string, :limit	=> 80 # "John Doe"
      t.column :notes, :text
    end
  end

  def self.down
    drop_table :affiliations
  end
end
