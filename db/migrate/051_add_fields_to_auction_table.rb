class AddFieldsToAuctionTable < ActiveRecord::Migration
  def self.up
    add_column :auctions, :quantity, :integer
    add_column :auctions, :allow_partial, :boolean
    add_column :auctions, :min_quantity, :integer
    add_column :auctions, :feedback_id, :integer
    add_column :auctions, :creditworth_id, :integer
    add_column :auctions, :timeliness_id, :integer
    add_column :auctions, :integrity_id, :integer
    add_column :auctions, :plu_stickered, :boolean
    add_column :auctions, :temperature, :decimal, :precision => 10, :scale => 2, :default => 0
    add_column :auctions, :date_to_pickup, :datetime
    
    create_table :creditworth do |t|
      t.column :sort_order, :integer
      t.column :description, :string
    end
 
    create_table :feedback do |t|
      t.column :sort_order, :integer
      t.column :description, :string
    end
    
    create_table :integrity do |t|
      t.column :sort_order, :integer
      t.column :description, :string
    end

   create_table :timeliness do |t|
     t.column :sort_order, :integer
     t.column :description, :string
   end

    Creditworth.create :sort_order => 1, :description => "1000M"
    Creditworth.create :sort_order => 2, :description => "100M"
    Creditworth.create :sort_order => 3, :description => "50M"
    Creditworth.create :sort_order => 4, :description => "25M"
 
    Feedback.create :sort_order => 1, :description => "Positive"
    Feedback.create :sort_order => 2, :description => "Mixed"
    Feedback.create :sort_order => 3, :description => "Negative"
 
    Integrity.create :sort_order => 1, :description => "XXXX"
    Integrity.create :sort_order => 2, :description => "XXX"
    Integrity.create :sort_order => 3, :description => "XX"
    Integrity.create :sort_order => 4, :description => "X"

    Timeliness.create :sort_order => 1, :description => "AA"
    Timeliness.create :sort_order => 2, :description => "A"
    Timeliness.create :sort_order => 3, :description => "AB"
    Timeliness.create :sort_order => 4, :description => "B"
    Timeliness.create :sort_order => 5, :description => "C"
    Timeliness.create :sort_order => 6, :description => "D"
    Timeliness.create :sort_order => 7, :description => "E"
    Timeliness.create :sort_order => 8, :description => "F"
       
  end

  def self.down
    drop_table :feedback
    drop_table :creditworth
    drop_table :timeliness
    drop_table :integrity
    remove_column :auctions, :quantity
    remove_column :auctions, :allow_partial
    remove_column :auctions, :min_quantity
    remove_column :auctions, :min_feedback
    remove_column :auctions, :min_creditworth
    remove_column :auctions, :min_timeliness
    remove_column :auctions, :min_integrity
    remove_column :auctions, :plu_stickered
    remove_column :auctions, :temperature
    remove_column :auctions, :date_to_pickup
  end
end