class AddApprovalsToAffiliations < ActiveRecord::Migration
  def self.up
    add_column :affiliations, :approved_to_buy, :boolean
    add_column :affiliations, :approved_to_sell, :boolean
  end

  def self.down
    remove_column :affiliations, :approved_to_buy
    remove_column :affiliations, :approved_to_sell
  end
end