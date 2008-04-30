class ChangeLengthForTokens < ActiveRecord::Migration
  def self.up
    change_column :tokens, :last_digits, :string, :limit => 4
    change_column :tokens, :crypted_number, :text
  end

  def self.down
    change_column :tokens, :crypted_number, :string
    change_column :tokens, :last_digits, :limit => 40
  end
end