class CreateInvitationCodes < ActiveRecord::Migration
  def self.up
    create_table :invitation_codes do |t|
      t.column :user_id, :integer
      t.column :role_id, :integer
      t.column :code, :string
      t.column :response_count, :integer, :default => 0
    end
  end

  def self.down
    drop_table :invitation_codes
  end
end
