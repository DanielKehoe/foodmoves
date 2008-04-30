class CreateAuctions < ActiveRecord::Migration
  def self.up
    create_table :auctions do |t|
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :date_to_start, :datetime
      t.column :date_to_end, :datetime
      t.column :seller_id, :integer
      t.column :address_id, :integer
  		t.column :lat, :decimal, :precision => 15, :scale => 10, :default => 0 # latitude
      t.column :lng, :decimal, :precision => 15, :scale => 10, :default => 0 # longitude
      t.column :reserve_price, :decimal, :precision => 10, :scale => 2, :default => 0 
      t.column :minimum_bid, :decimal, :precision => 10, :scale => 2, :default => 0 
      t.column :bid_increment, :decimal, :precision => 10, :scale => 2, :default => 0 
      t.column :how_many_bids, :integer
      t.column :date_last_bid, :datetime
      t.column :current_bid, :decimal, :precision => 10, :scale => 2, :default => 0 
      t.column :closed, :boolean, :default => 0
      t.column :buyer_id, :integer
      t.column :certification_id, :integer
      t.column :color_id, :integer
      t.column :condition_id, :integer
      t.column :food_id, :integer
      t.column :grown_id, :integer
      t.column :pack_id, :integer
      t.column :per_case_id, :integer
      t.column :quality_id, :integer
      t.column :size_id, :integer
      t.column :weight_id, :integer
      t.column :shipping_from, :string
      t.column :description, :string
    end
  end

  def self.down
    drop_table :auctions
  end
end
