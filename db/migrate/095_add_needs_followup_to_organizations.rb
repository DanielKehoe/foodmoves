class AddNeedsFollowupToOrganizations < ActiveRecord::Migration
  def self.up
    
    add_column :organizations, :needs_review, :boolean, :default => false
    add_column :organizations, :liability_limits_id, :integer, :default => nil
    
    create_table :liability_limits do |t|
      t.column :sort_order, :decimal, :precision => 8, :scale => 2
      t.column :description, :string
    end

    LiabilityLimit.create :description => "$1,000,000 + More (Liability)", :sort_order => 1
    LiabilityLimit.create :description => "$500,000 + More (Liability)", :sort_order => 2
    LiabilityLimit.create :description => "$250,000 + More (Liability)", :sort_order => 3
    LiabilityLimit.create :description => "none", :sort_order => 4
  end

  def self.down
    remove_column :organizations, :needs_review
    remove_column :organizations, :liability_limits_id
    drop_table :liability_limits
  end
end
