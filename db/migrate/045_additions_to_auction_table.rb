class AdditionsToAuctionTable < ActiveRecord::Migration
  def self.up
    remove_column :auctions, :certification_id
    add_column :auctions, :for_export, :boolean
    add_column :auctions, :origin_region_id, :integer
    add_column :auctions, :origin_country_id, :integer
    create_table :auctions_certifications, :id => false do |t|
      t.column :auction_id, :integer, :null => false
      t.column :certification_id, :integer, :null => false
    end

  end

  def self.down
    add_column :auctions, :certification_id, :integer
    remove_column :auctions, :for_export
    remove_column :auctions, :origin_region_id
    remove_column :auctions, :origin_country_id
    drop_table :auctions_certifications
  end
end
