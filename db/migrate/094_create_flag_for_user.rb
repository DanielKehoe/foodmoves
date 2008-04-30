class CreateFlagForUser < ActiveRecord::Migration
  def self.up
    
    add_column :users, :flag_for_user_id, :integer
    
    create_table :flag_for_users do |t|
      t.column :name, :string
      t.column :sort_order, :decimal, :precision => 8, :scale => 2
      t.column :color, :string
      t.column :description, :string
    end

    FlagForUser.create :name => "vip", :sort_order => 1, :color => "purple"
    FlagForUser.create :name => "problem", :sort_order => 2, :color => "red"
    FlagForUser.create :name => "potential problem", :sort_order => 3, :color => "yellow"
    FlagForUser.create :name => "staff", :sort_order => 4, :color => "green"
    FlagForUser.create :name => "unflagged", :sort_order => 5, :color => "blue"
    FlagForUser.create :name => "special", :sort_order => 6, :color => "pink"
  end

  def self.down
    remove_column :users, :flag_for_user_id
    drop_table :flag_for_users
  end
end

