# == Schema Information
# Schema version: 111
#
# Table name: addresses
#
#  id               :integer(11)   not null, primary key
#  created_at       :datetime      
#  updated_at       :datetime      
#  addressable_id   :integer(11)   default(0), not null
#  addressable_type :string(255)   default(""), not null
#  tag_for_address  :string(255)   
#  lat              :decimal(15, 1 
#  lng              :decimal(15, 1 
#  admin_area_id    :integer(11)   
#  locality         :string(255)   
#  thoroughfare     :string(255)   
#  postal_code      :string(255)   
#  region_id        :integer(11)   
#  country_id       :integer(11)   
#

class Address < ActiveRecord::Base

  has_one :auction
  belongs_to :addressable, :polymorphic => true
  has_one :user, :as => :addressable
  has_one :organization, :as => :addressable
  has_one :prospect, :as => :addressable
  
  # from GeoKit plugin
  acts_as_mappable
  
  def after_initialize
    if country_id.nil?
      # default to North America and USA for any new address
      self.region_id = Geographies::Region.find_by_name('North America').id
      self.country_id = Geographies::Country.find_by_code('US').id
    end
  end
        
  def before_save
    unless locality.blank? 
      self.locality = self.locality.downcase
      self.locality = self.locality.titleize
    end
    unless thoroughfare.blank? 
      unless thoroughfare.include?("PO") 
        self.thoroughfare = self.thoroughfare.downcase
        self.thoroughfare = self.thoroughfare.titleize
      end
    end
    unless postal_code.blank? 
      self.postal_code.upcase!
    end
    @location = GeoKit::Geocoders::MultiGeocoder.geocode("#{thoroughfare}, #{locality}, #{admin_area_abbr}, #{country}")
    if @location.success
      self.lat = @location.lat
      self.lng = @location.lng
    end
  end

  def country_name
    unless country_id.nil?
      Geographies::Country.find(country_id).name
    else
      'US'
    end
  end
  
  def country_code
    unless country_id.nil?
      begin
        Geographies::Country.find(country_id).code.upcase or raise ActiveRecord::RecordNotFound
      rescue ActiveRecord::RecordNotFound
        'US'
      end
    else
      'US'
    end
  end
    
  def country
    country_name
  end

  def admin_area_name
    unless admin_area_id.nil?
      Geographies::AdminArea.find(admin_area_id).name
    end
  end

  def admin_area_abbr
    unless admin_area_id.nil?
      code = Geographies::AdminArea.find(admin_area_id).code
      if code.nil?
        code = Geographies::AdminArea.find(admin_area_id).name
      end
      code
    end
  end
    
  def admin_area
    admin_area_abbr
  end
      
  def label_for_admin_area
    unless country_id.nil?
      has_states = %w{ AU DE ES IN MX UG US }
      has_provinces = %w{ CA }
      has_counties = %w{ UK }
      has_departments = %w{ FR }
      if has_states.include?(country_code.upcase) then 'State' 
      elsif has_provinces.include?(country_code.upcase) then 'Province' 
      elsif has_counties.include?(country_code.upcase) then 'County' 
      elsif has_departments.include?(country_code.upcase) then 'Department'
      else 'Area' 
      end
    else
      'State or Province'
    end
  end

  def label_for_locality
    'City'
  end
 
  def label_for_thoroughfare
    'Address'
  end
  
  def label_for_postal_code
    unless country_id.nil?
      case country_code.upcase 
        when 'US' then 'ZIP Code' 
        else 'Postal Code' 
      end
    else
      'Postal Code'
    end
  end

  def tag_plus_city
      "#{tag_for_address} (#{locality})"
  end
  
  def city_state
    if country_code.upcase == 'US'
      "#{locality}, #{admin_area_abbr}"
    elsif country_code.upcase == 'CA' 
      "#{locality}, #{admin_area_abbr}, Canada"
    else
      "#{locality}, #{country}"
    end
  end
     
  def address
    if country_code.upcase == 'US'
      "#{thoroughfare}, #{locality}, #{admin_area_abbr}"
    elsif country_code.upcase == 'CA' 
      "#{thoroughfare}, #{locality}, #{admin_area_abbr}, Canada"
    else
      "#{thoroughfare}, #{locality}, #{country}"
    end
  end

  def location
    if country_code.upcase == 'US'
      "#{locality}, #{admin_area_abbr}"
    elsif country_code.upcase == 'CA' 
      "#{locality}, #{admin_area_abbr}, Canada"
    else
      "#{locality}, #{country}"
    end
  end
  
  def address_block
    if country_code.upcase == 'US'
      "#{thoroughfare}<br />#{locality}, #{admin_area_abbr} #{postal_code}"
    elsif country_code.upcase == 'MX' 
      "#{thoroughfare}<br />#{postal_code} #{locality}, #{admin_area_abbr}<br />#{country}"
    else
      "#{thoroughfare}<br />#{locality}, #{admin_area_abbr} #{postal_code}<br />#{country}"
    end
  end
end
