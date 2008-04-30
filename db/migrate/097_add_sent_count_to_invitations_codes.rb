class AddSentCountToInvitationsCodes < ActiveRecord::Migration
  def self.up
		add_column :invitation_codes, :sent_count, :integer, :default => 0
  end

  def self.down
		remove_column :invitation_codes, :sent_count
  end
end
