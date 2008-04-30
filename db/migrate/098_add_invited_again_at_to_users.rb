class AddInvitedAgainAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :invited_again_at, :datetime
  end

  def self.down
    remove_column :users, :invited_again_at
  end
end

