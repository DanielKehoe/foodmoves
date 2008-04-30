# == Schema Information
# Schema version: 111
#
# Table name: watched_locations
#
#  id            :integer(11)   not null, primary key
#  user_id       :string(255)   
#  name          :string(255)   
#  locality      :string(255)   
#  admin_area_id :integer(11)   
#  country_id    :integer(11)   
#  region_id     :integer(11)   
#  lat           :decimal(15, 1 default(0.0)
#  lng           :decimal(15, 1 default(0.0)
#  created_at    :datetime      
#  updated_at    :datetime      
#

class WatchedLocation < ActiveRecord::Base
  
  belongs_to :user
  
  # virtual attributes
  attr_accessor :auctions
  
  # from GeoKit plugin
  acts_as_mappable
  
  validates_presence_of :locality, :message => "You did not enter a city!"

  def before_save
    unless locality.blank? 
      self.locality = self.locality.downcase
      self.locality = self.locality.titleize
      country = Geographies::Country.find(self.country_id)
      admin_area = Geographies::AdminArea.find(self.admin_area_id)
      @location = GeoKit::Geocoders::MultiGeocoder.geocode("#{self.locality}, #{admin_area.name}, #{country.name}")
      if @location.success
        self.lat = @location.lat
        self.lng = @location.lng
      end
      if country.code.upcase == 'US'
        self.name = "#{self.locality}, #{admin_area.code}"
      elsif country.code.upcase == 'CA' 
        self.name = "#{self.locality}, #{admin_area.code}, Canada"
      else
        self.name = "#{self.locality}, #{country.name}"
      end
    end
  end
    
end
