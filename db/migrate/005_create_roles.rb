class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.column :title, :string
    end
    
    create_table "roles_users", :id => false, :force => true do |t|
      t.column "role_id", :integer
      t.column "user_id", :integer
    end
    
  end

  def self.down
    drop_table :roles
    drop_table :roles_users
  end
  end
