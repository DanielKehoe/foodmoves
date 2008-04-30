class AddIndustryRoles < ActiveRecord::Migration
  def self.up
    create_table :survey_questions do |t|
      t.column :of_type, :string
      t.column :sort_order, :decimal, :precision => 8, :scale => 2
      t.column :answer, :string
      t.column :responses, :integer
    end
    
    add_column :users, :industry_role, :string
    add_column :organizations, :industry_role, :string
    
    IndustryRole.create :sort_order => 1, :answer => "Grower"
    IndustryRole.create :sort_order => 2, :answer => "Co-op"
    IndustryRole.create :sort_order => 3, :answer => "Shipper/distributor"
    IndustryRole.create :sort_order => 4, :answer => "Importer"  
    IndustryRole.create :sort_order => 5, :answer => "Broker" 
    IndustryRole.create :sort_order => 6, :answer => "Wholesaler"     
    IndustryRole.create :sort_order => 7, :answer => "Processor" 
    IndustryRole.create :sort_order => 8, :answer => "Terminal market"                       
    IndustryRole.create :sort_order => 9, :answer => "Retailer" 
    IndustryRole.create :sort_order => 10, :answer => "Transportation"
    IndustryRole.create :sort_order => 11, :answer => "Insurance" 
    IndustryRole.create :sort_order => 12, :answer => "Journalist" 
    IndustryRole.create :sort_order => 13, :answer => "Industry analyst"
    IndustryRole.create :sort_order => 14, :answer => "Other"
    
  end

  def self.down
    remove_column :users, :industry_role
    remove_column :organizations, :industry_role
    drop_table :survey_questions
  end
end
