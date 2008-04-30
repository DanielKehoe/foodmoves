class AddBuynowsaleToBids < ActiveRecord::Migration
  def self.up
    add_column :bids, :buy_now_sale, :boolean, :default => false
  end

  def self.down
    remove_column :bids, :buy_now_sale
  end
end

