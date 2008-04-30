class CreateBids < ActiveRecord::Migration
  def self.up
    create_table :bids do |t|
      t.column :closed, :boolean, :default => false 
      t.column :winner, :boolean, :default => false 
      t.column :user_id, :integer
      t.column :auction_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :closed_at, :datetime
      t.column :amount, :decimal, :precision => 10, :scale => 2, :default => 0 
      t.column :quantity, :integer, :default => 0 
    end
  end

  def self.down
    drop_table :bids
  end
end
