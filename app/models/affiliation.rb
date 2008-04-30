# == Schema Information
# Schema version: 111
#
# Table name: affiliations
#
#  id               :integer(11)   not null, primary key
#  user_id          :integer(11)   
#  created_at       :datetime      
#  updated_at       :datetime      
#  approved         :boolean(1)    
#  reviewed_at      :datetime      
#  called_by        :string(80)    
#  talked_to        :string(80)    
#  notes            :text          
#  organization_id  :integer(11)   
#  approved_to_buy  :boolean(1)    
#  approved_to_sell :boolean(1)    
#

class Affiliation < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization

  def self.count_all_pending
    count :conditions => ["approved = 0"]
  end
    
  def self.find_pending
    find(:all,
          :conditions => ["approved = 0"],
          :order => "created_at DESC")
  end

  def self.find_approved
    find(:all,
          :conditions => ["approved = 1"],
          :order => "created_at DESC")
  end
  
  def self.find_all_approved_this_week
    find(:all,
          :conditions => ["approved = 1 and reviewed_at > ?", 1.week.ago.to_s(:db)],
          :order => "reviewed_at DESC")
  end
  
  def self.find_all_not_approved
    find(:all,
          :conditions => ["approved = 0"],
          :order => "created_at DESC")
  end
  
  
  def before_save
    if self.approved_to_sell or self.approved_to_buy
      self.approved = true
    end
  end
     
end
