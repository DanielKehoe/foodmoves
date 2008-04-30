class AddPhoneToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :first_phone, :string
  end

  def self.down
    remove_column :users, :first_phone
  end
end
