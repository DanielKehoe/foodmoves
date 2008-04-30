class ChangeBluebookMemberTable < ActiveRecord::Migration
  def self.up
		rename_column :bluebook_members, :tradename, :name
  end

  def self.down
		rename_column :bluebook_members, :name, :tradename
  end
end
