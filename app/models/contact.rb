# == Schema Information
# Schema version: 111
#
# Table name: contacts
#
#  id              :integer(11)   not null, primary key
#  first_name      :string(80)    
#  last_name       :string(80)    
#  email           :string(80)    
#  time_zone       :string(80)    default("Etc/UTC")
#  region_id       :integer(11)   
#  country_id      :integer(11)   
#  industry_role   :string(80)    
#  starts_as       :string(80)    
#  created_by      :string(80)    
#  created_at      :datetime      
#  updated_at      :datetime      
#  organization_id :integer(11)   
#  title           :string(255)   
#

class Contact < ActiveRecord::Base
  
  belongs_to :organization
  
  validates_uniqueness_of :email, :case_sensitive => false
  
  def after_initialize
    if country_id.nil?
      # default to North America and USA for any new user
      self.region_id = 9 # North America
      self.country_id = 239 # USA
    end
  end
  
  def before_save
    unless first_name.nil?
      unless first_name.include?(' ') 
        self.first_name = first_name.underscore # McGoo => mc_goo, Smith => smith, SMITH => smith 
        self.first_name = self.first_name.camelize # Mc_goo => McGoo, smith => Smith
      else
        self.first_name = first_name.downcase
        self.first_name = self.first_name.titleize
      end
    end
    unless last_name.nil?
      unless last_name.include?(' ') 
        self.last_name = last_name.underscore # McGoo => mc_goo, Smith => smith, SMITH => smith 
        self.last_name = self.last_name.camelize # Mc_goo => McGoo, smith => Smith
      else
        self.last_name = last_name.downcase
        self.last_name = self.last_name.titleize
      end
    end
    unless email.nil? 
      self.email.downcase!
    end
  end
  
  def name
    unless last_name.blank?
      "#{first_name} #{last_name}"
    else
      email
    end
  end

  def name_with_title
    unless title.blank?
      "#{title} #{name}"
    else
      name
    end
  end
    
  def name_reversed
    unless last_name.blank?
      "#{last_name}, #{first_name}"
    else
      email
    end
  end
  
  def country_name
    unless country_id.nil?
      Geographies::Country.find(country_id).name
    else
      'USA'
    end
  end
  
end
