class AddDescriptionToRolesTable < ActiveRecord::Migration
  def self.up
		add_column :roles, :description, :string
		
		Role.create :title => 'admin', 
		            :description => 'all administrative privileges'
		Role.create :title => 'manager', 
		            :description => 'some administrative privileges'	
		Role.create :title => 'support', 
		            :description => 'some administrative privileges'
  	Role.create :title => 'member', 
  	            :description => 'no administrative privileges'
    Role.create :title => 'guest', 
  	            :description => 'no administrative privileges'
        
  end
  
  def self.down
		remove_column :roles, :description
  end
end
