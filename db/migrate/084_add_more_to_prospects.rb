class AddMoreToProspects < ActiveRecord::Migration
  def self.up
    add_column :prospects, :call_result, :string, :default => 'not called'
    add_column :prospects, :updated_by, :string, :default => nil
  end

  def self.down
    remove_column :prospects, :call_result
    remove_column :prospects, :updated_by
  end
end