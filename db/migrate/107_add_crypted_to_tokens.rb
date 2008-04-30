class AddCryptedToTokens < ActiveRecord::Migration
  def self.up
    remove_column :tokens, :encrypted
    add_column :tokens, :crypted_number, :string, :limit => 40
    add_column :tokens, :salt, :string, :limit => 40
  end

  def self.down
    add_column :tokens, :encrypted, :string
    remove_column :tokens, :crypted_number
    remove_column :tokens, :salt
  end
end
