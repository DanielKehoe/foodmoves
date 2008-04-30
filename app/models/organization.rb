# == Schema Information
# Schema version: 111
#
# Table name: organizations
#
#  id                  :integer(11)   not null, primary key
#  created_at          :datetime      
#  updated_at          :datetime      
#  name                :string(255)   
#  industry_role       :string(255)   
#  rated_by            :string(255)   default("other")
#  bluebook_member_id  :integer(6)    
#  created_by          :integer(11)   
#  of_type             :string(255)   default("Organization")
#  locality            :string(80)    
#  admin_area_id       :integer(11)   
#  country_id          :integer(11)   
#  admin_area_abbr     :string(255)   
#  country_name        :string(255)   
#  region_id           :integer(11)   
#  email               :string(80)    
#  website             :string(80)    
#  source              :string(34)    default("other")
#  created_by_name     :string(255)   
#  lat                 :decimal(15, 1 default(0.0)
#  lng                 :decimal(15, 1 default(0.0)
#  person              :string(255)   
#  thoroughfare        :string(255)   
#  postal_code         :string(255)   
#  phone               :string(255)   
#  call_result         :string(255)   default("not called")
#  updated_by          :string(255)   
#  acct_exec_id        :integer(11)   
#  paca_license        :string(30)    
#  bluebook_password   :string(30)    
#  feedback_id         :integer(11)   
#  creditworth_id      :integer(11)   
#  timeliness_id       :integer(11)   
#  integrity_id        :integer(11)   
#  needs_review        :boolean(1)    
#  liability_limits_id :integer(11)   
#  do_not_contact      :boolean(1)    
#

class Organization < ActiveRecord::Base

  # support for single-table inheritance (use "of_type" to avoid conflict with reserved word "type")
  set_inheritance_column :of_type
  
  has_many :assets, :as => :attachable
  has_one :card_info, :dependent => :destroy
  has_many :phones, :as => :phonable, :dependent => :destroy
  has_many :addresses, :as => :addressable, :dependent => :destroy
  belongs_to :bluebook_member, :conditions => "rated_by = 'bluebook'"
  has_many :affiliations, :dependent => :destroy
  has_many :users, :through => :affiliations
  has_many :contacts, :dependent => :destroy
  belongs_to :creditworth
  belongs_to :feedback
  belongs_to :integrity
  belongs_to :timeliness
  belongs_to :liability_limit
  belongs_to :administrator, :foreign_key => 'acct_exec_id'
  belongs_to :user, :foreign_key => 'created_by'
  
  validates_uniqueness_of :name, :case_sensitive => false

  def billing_approved
    false
    if creditworth_id < 5
      true
    end
  end
               
  def name_plus_location
    unless self.addresses.size == 0
      "#{name} (#{self.addresses.first.location})"
    else
      unless country_name.blank?
        if country_name.upcase == 'USA'
          "#{name.titlecase} (#{locality.titlecase}, #{admin_area_abbr.titlecase})"
        elsif country_name.upcase == 'CANADA'  
          "#{name.titlecase} (#{locality.titlecase}, #{admin_area_abbr.titlecase}, Canada)"
        else
          "#{name.titlecase} (#{locality.titlecase}, #{country_name.titlecase})"
        end
      else
        "#{name}"
      end
    end
  end
  
  def location
    unless self.addresses.size == 0
      "#{self.addresses.first.location}"
    else
      unless country_id.blank?
        if country_id == 239 # US
          "#{locality}, #{admin_area_abbr.titlecase}"
        elsif country_id == 48 # Canada
          "#{locality}, #{admin_area_abbr.titlecase}, Canada"
        else
          "#{locality}, #{country_name.titlecase}"
        end
      else
        "#{locality}"
      end
    end
  end

  def before_save
    if region_id.nil?
      unless country_name.nil?
        nation = Geographies::Country.find_by_name(country_name)
        unless nation.nil?
          self.region_id = nation.parent.id
        end
      end
    end
    if country_id.nil?
      unless country_name.nil?
        nation = Geographies::Country.find_by_name(country_name)
        self.country_id = nation.id
      end
    end
    if country_name.nil?
      unless country_id.nil?
        nation = Geographies::Country.find(country_id)
        self.country_name = nation.name
      end
    end
    if admin_area_id.nil?
      unless admin_area_abbr.nil?
        state = Geographies::AdminArea.find_by_code(admin_area_abbr.titlecase)
        self.admin_area_id = state.id
      end           
    end
    if admin_area_abbr.nil?
      unless admin_area_id.nil?
        state = Geographies::AdminArea.find(admin_area_id)
        self.admin_area_abbr = state.code
      end           
    end
    unless locality.blank? 
      self.locality = self.locality.downcase
      self.locality = self.locality.titleize
      geoplace = GeoKit::Geocoders::MultiGeocoder.geocode("#{self.locality}, #{self.admin_area_abbr}, #{self.country_name}")
      if geoplace.success
        self.lat = geoplace.lat
        self.lng = geoplace.lng
      end
    end
  end
end
