class AddHowHeard < ActiveRecord::Migration
  def self.up
    
    add_column :users, :how_heard, :string

    HowHeard.create :sort_order => 1, :answer => "friend or associate"
    HowHeard.create :sort_order => 2, :answer => "tradeshow"
    HowHeard.create :sort_order => 3, :answer => "call by Foodmoves"
    HowHeard.create :sort_order => 4, :answer => "email from Foodmoves"  
    HowHeard.create :sort_order => 5, :answer => "web search or surfing"
    HowHeard.create :sort_order => 6, :answer => "radio or tv"
    HowHeard.create :sort_order => 7, :answer => "truck ad" 
    HowHeard.create :sort_order => 8, :answer => "The Packer"     
    HowHeard.create :sort_order => 9, :answer => "The Produce News" 
    HowHeard.create :sort_order => 10, :answer => "The Perishable Pundit"                       
    HowHeard.create :sort_order => 11, :answer => "Blue Prints" 
    HowHeard.create :sort_order => 12, :answer => "other news article"
    HowHeard.create :sort_order => 13, :answer => "other source"

  end

  def self.down
    remove_column :users, :how_heard
  end
end
