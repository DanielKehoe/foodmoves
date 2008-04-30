class AddStartsAsToUserTable < ActiveRecord::Migration
  def self.up
		add_column :users, :starts_as, :string
		add_column :survey_questions, :description, :string
		
		item = IndustryRole.find_by_answer("Grower")
		item.update_attribute(:description, "seller")
    item = IndustryRole.find_by_answer("Co-op")
    item.update_attribute(:description, "seller")
    item = IndustryRole.find_by_answer("Shipper/distributor")
    item.update_attribute(:description, "seller")
    item = IndustryRole.find_by_answer("Importer")
    item.update_attribute(:description, "buyer")
    item = IndustryRole.find_by_answer("Broker")
    item.update_attribute(:description, "buyer")
    item = IndustryRole.find_by_answer("Wholesaler")
    item.update_attribute(:description, "buyer")     
    item = IndustryRole.find_by_answer("Processor")
    item.update_attribute(:description, "buyer")
    item = IndustryRole.find_by_answer("Terminal market")
    item.update_attribute(:description, "buyer")                      
    item = IndustryRole.find_by_answer("Retailer")
    item.update_attribute(:description, "buyer")
    item = IndustryRole.find_by_answer("Transportation")
    item.update_attribute(:description, "other")
    item = IndustryRole.find_by_answer("Insurance")
    item.update_attribute(:description, "other")
    item = IndustryRole.find_by_answer("Journalist")
    item.update_attribute(:description, "other")
    item = IndustryRole.find_by_answer("Industry analyst")
    item.update_attribute(:description, "other")
    item = IndustryRole.find_by_answer("Other")
    item.update_attribute(:description, "other")
  end

  def self.down
		remove_column :users, :starts_as
		remove_column :survey_questions, :description
  end
end