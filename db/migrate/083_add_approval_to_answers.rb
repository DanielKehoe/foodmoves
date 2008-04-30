class AddApprovalToAnswers < ActiveRecord::Migration
  def self.up
    add_column :answers, :approved, :boolean, :default => false
  end

  def self.down
    remove_column :answers, :approved
  end
end
