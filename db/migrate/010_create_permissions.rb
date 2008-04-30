class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.column :user_id, :integer
      t.column :role_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
    drop_table :roles_users
  end

  def self.down
    drop_table :permissions
    
    create_table "roles_users", :id => false, :force => true do |t|
      t.column "role_id", :integer
      t.column "user_id", :integer
    end
  end
end
