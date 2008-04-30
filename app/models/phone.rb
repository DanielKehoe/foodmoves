# == Schema Information
# Schema version: 111
#
# Table name: phones
#
#  id            :integer(11)   not null, primary key
#  created_at    :datetime      
#  updated_at    :datetime      
#  phonable_id   :integer(11)   default(0), not null
#  phonable_type :string(255)   default(""), not null
#  tag_for_phone :string(255)   
#  number        :string(255)   
#  country_code  :string(255)   
#  locality_code :string(255)   
#  local_number  :string(255)   
#  region_id     :integer(11)   
#

class Phone < ActiveRecord::Base
  
  belongs_to :phonable, :polymorphic => true
  has_one :user, :as => :phonable
  has_one :organization, :as => :phonable
  has_one :prospect, :as => :phonable
  
  def after_initialize
    # logger.info "\n\n after_initialize \n\n"
    # default to North America and US for any new phone
    self.region_id = '9'
    self.country_id = '239'
    # logger.info "\n\n self.country_id #{self.country_id} \n\n"
  end
  
  def before_save
    unless self.country_id.nil?
      self.country_code = Geographies::Country.find(self.country_id).phone_code
    end
    self.locality_code = locality_code.strip
    self.locality_code = locality_code.squeeze(' ')
    self.locality_code = locality_code.tr('(', '')
    self.locality_code = locality_code.tr(')', '')
    self.local_number = local_number.strip
    unless self.local_number.index(' ') == 3
      self.local_number = local_number.squeeze(' ')
    end
    self.local_number = local_number.tr('.', ' ')
    self.local_number = local_number.tr('-', ' ')
    if country_code.to_s.first(2) == '+1'
      self.number = "#{country_code} #{local_number}" 
    else
      unless country_code == locality_code
        self.number = "+#{country_code} #{locality_code} #{local_number}" 
      else
        self.number = "+1 #{locality_code} #{local_number}"
      end
    end
  end
 
  def skype
    "+#{country_code}#{locality_code}#{local_number.tr(' ', '')}"
  end
      
  def usa_number
    "(#{locality_code}) #{local_number.tr(' ', '-')}"
  end
  
  def localized(user)
    north_america = %w{ '239' '48' }
    if north_america.include?(user.country_id.to_s) and country_code == '1'
      usa_number
    else
      number
    end
  end
  
end
