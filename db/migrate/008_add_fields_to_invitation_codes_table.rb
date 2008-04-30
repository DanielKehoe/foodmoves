class AddFieldsToInvitationCodesTable < ActiveRecord::Migration
  def self.up
		add_column :invitation_codes, :created_at, :datetime
		add_column :invitation_codes, :updated_at, :datetime
  end

  def self.down
		remove_column :invitation_codes, :updated_at
		remove_column :invitation_codes, :created_at
  end
end
