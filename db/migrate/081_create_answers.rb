class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.column :sort_order, :decimal, :precision => 8, :scale => 2, :default => 50.0
      t.column :user_id, :integer
      t.column :created_by, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :topic, :string
      t.column :question, :string
      t.column :answer, :text
    end
  end

  def self.down
    drop_table :answers
  end
end
