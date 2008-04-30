class AddLastDigitsToTokens < ActiveRecord::Migration
  def self.up
    rename_column :tokens, :salt, :last_digits
  end

  def self.down
    rename_column :tokens, :last_digits, :salt
  end
end
