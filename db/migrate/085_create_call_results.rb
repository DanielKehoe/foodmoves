class CreateCallResults < ActiveRecord::Migration
  def self.up
    create_table :call_results do |t|
      t.column :sort_order, :decimal, :precision => 8, :scale => 2, :default => 50.0
      t.column :name, :string
      t.column :description, :string
    end
    
    CallResult.create :sort_order => 0.5, :name => "Not Called"
    CallResult.create :sort_order => 1, :name => "Send Brochure"
    CallResult.create :sort_order => 2, :name => "Emailed Invite"
    CallResult.create :sort_order => 3, :name => "Set Up Trading"
    CallResult.create :sort_order => 4, :name => "Coached Online"  
    CallResult.create :sort_order => 5, :name => "Call Other Number" 
    CallResult.create :sort_order => 6, :name => "Call Corporate"     
    CallResult.create :sort_order => 7, :name => "DNC (Do Not Call)" 
    CallResult.create :sort_order => 8, :name => "Gatekeeper"                       
    CallResult.create :sort_order => 9, :name => "Hung Up" 
    CallResult.create :sort_order => 10, :name => "Not Interested"
    CallResult.create :sort_order => 11, :name => "Not Available" 
    CallResult.create :sort_order => 12, :name => "No Answer" 
    CallResult.create :sort_order => 13, :name => "Fax Line"
    CallResult.create :sort_order => 15, :name => "Out of Service"
    CallResult.create :sort_order => 16, :name => "Voicemail"
    CallResult.create :sort_order => 17, :name => "Wrong Number"
    CallResult.create :sort_order => 18, :name => "Other"

  end

  def self.down
    drop_table :call_results
  end
end
