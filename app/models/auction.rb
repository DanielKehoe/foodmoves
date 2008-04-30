# == Schema Information
# Schema version: 111
#
# Table name: auctions
#
#  id                :integer(11)   not null, primary key
#  created_at        :datetime      
#  updated_at        :datetime      
#  date_to_start     :datetime      
#  date_to_end       :datetime      
#  seller_id         :integer(11)   
#  address_id        :integer(11)   
#  lat               :decimal(15, 1 default(0.0)
#  lng               :decimal(15, 1 default(0.0)
#  reserve_price     :decimal(10, 2 default(0.0)
#  minimum_bid       :decimal(10, 2 default(0.0)
#  bid_increment     :decimal(10, 2 default(0.0)
#  how_many_bids     :integer(11)   default(0)
#  date_last_bid     :datetime      
#  current_bid       :decimal(10, 2 default(0.0)
#  closed            :boolean(1)    
#  buyer_id          :integer(11)   
#  color_id          :integer(11)   
#  condition_id      :integer(11)   
#  food_id           :integer(11)   
#  grown_id          :integer(11)   
#  pack_id           :integer(11)   
#  per_case_id       :integer(11)   
#  quality_id        :integer(11)   
#  size_id           :integer(11)   
#  weight_id         :integer(11)   
#  shipping_from     :string(255)   
#  description       :string(255)   
#  for_export        :boolean(1)    
#  origin_region_id  :integer(11)   
#  origin_country_id :integer(11)   
#  plu               :integer(11)   
#  quantity          :integer(11)   
#  allow_partial     :boolean(1)    
#  min_quantity      :integer(11)   
#  feedback_id       :integer(11)   
#  creditworth_id    :integer(11)   
#  timeliness_id     :integer(11)   
#  integrity_id      :integer(11)   
#  plu_stickered     :boolean(1)    
#  temperature       :decimal(10, 2 default(0.0)
#  date_to_pickup    :datetime      
#  celsius           :boolean(1)    
#  barcoded          :boolean(1)    
#  lot_number        :string(255)   
#  pickup_limit      :integer(11)   
#  cases_per_pallet  :integer(11)   
#  pallets           :integer(11)   
#  test_only         :boolean(1)    
#  organic           :boolean(1)    
#  fair_trade        :boolean(1)    
#  pickup_number     :string(255)   
#  kosher            :boolean(1)    
#  buy_now_price     :decimal(10, 2 default(0.0)
#  last_bid_id       :integer(11)   
#  iced              :boolean(1)    
#  premium_service   :boolean(1)    
#  bill_me           :boolean(1)    
#  discount          :boolean(1)    
#  due_foodmoves     :decimal(10, 2 default(0.0)
#  date_paid         :datetime      
#  date_billed       :datetime      
#  consignment       :boolean(1)    
#

class Auction < ActiveRecord::Base
  
  has_many :assets, :as => :attachable
  has_many :bids, :dependent => :destroy
  has_and_belongs_to_many :certifications
  has_and_belongs_to_many :treatments
  belongs_to :user, :foreign_key => 'seller_id'
  belongs_to :address
  belongs_to :country, :class_name => 'Geographies::Country', :foreign_key => 'origin_country_id'
  belongs_to :condition
  belongs_to :quality
  belongs_to :color
  belongs_to :weight
  belongs_to :per_case
  belongs_to :size
  belongs_to :pack
  belongs_to :grown
  belongs_to :creditworth
  belongs_to :feedback
  belongs_to :integrity
  belongs_to :timeliness

  # convert user's local time to UTC for this attribute
  # (can't get tz_time_attributes to work, so adjust times in the before_save method)
  #tz_time_attributes :date_to_start, :date_to_end

  # from GeoKit plugin
  acts_as_mappable

  def self.find_sales(user_id)
    find(:all,
          :conditions => ["seller_id = :id and buyer_id IS NOT NULL",
            { :id => user_id } ],
          :order => "date_to_end DESC")
  end

  def self.find_consignments
    find(:all,
          :conditions => "test_only = 0 and consignment = 1",
          :order => "created_at DESC")
  end
    
  def excessive_risk?(user)
    false
    if user.organizations.first.nil?
      raise Exception, "You are not affiliated with a company and set up for trading."
    end
    # temporary change until we have Foodmoves Feedback ratings.
    # if user.organizations.first.feedback_id.nil?
    if false
      raise Exception, "Your company does not have a Foodmoves Feedback rating."
    end
    if user.organizations.first.creditworth_id.nil?
      raise Exception, "Your company does not have a Credit Worth rating."
    end
    if user.organizations.first.timeliness_id.nil?
      raise Exception, "Your company does not have a Timeliness rating."
    end
    if user.organizations.first.integrity_id.nil?
      raise Exception, "Your company does not have a Risk Factor rating."
    end
    # temporary change until we have Foodmoves Feedback ratings.
    # if user.organizations.first.feedback_id > self.feedback_id
    if false
      raise Exception, "Your company's Feedback rating does not meet the seller's minimum requirements."
    end   
    if user.organizations.first.creditworth_id > self.creditworth_id
      raise Exception, "Your company's Credit Worth rating does not meet the seller's minimum requirements."
    end
    if user.organizations.first.timeliness_id > self.timeliness_id
      raise Exception, "Your company's Timeliness rating does not meet the seller's minimum requirements."
    end
    if user.organizations.first.integrity_id > self.integrity_id
      raise Exception, "Your company's Risk Factor rating does not meet the seller's minimum requirements."
    end
  end
  
  def self.count_completed
    count :conditions => ["test_only = 0 and consignment = 0 and closed = 1 and buyer_id IS NOT NULL"]
  end
  
  def self.count_completed_last_72hrs
    count :conditions => ["test_only = 0 and consignment = 0 and closed = 1 and buyer_id IS NOT NULL and date_to_end > :since",
              { :since => Time.now - 1.day} ]
  end
  
  def self.count_completed_last_24hrs
    count :conditions => ["test_only = 0 and consignment = 0 and closed = 1 and buyer_id IS NOT NULL and date_to_end > :since",
              { :since => Time.now - 3.days} ]
  end
  
  def self.count_current
    count :conditions => ["test_only = 0 and consignment = 0 and date_to_end >= ?", Time.now]
  end

  def self.current_auctions
    Auction.find :all, 
                  :limit => 100,
                  :conditions => ["test_only = 0 and consignment = 0 and date_to_end >= ?", Time.now], 
                  :order => 'date_to_end DESC'
  end
 
  def self.current_auctions_alpha
    Auction.find :all, 
                  :limit => 100,
                  :conditions => ["test_only = 0 and consignment = 0 and date_to_end >= ?", Time.now], 
                  :order => 'description ASC'
  end
  
  def self.count_expiring
    count :conditions => ["closed = 0 and test_only = 0 and consignment = 0 and date_to_end < :tomorrow",
              { :tomorrow => Time.now + (24 * 60 * 60)} ]
  end

  def self.count_sellers_last_day
    count_by_sql ["select count(distinct seller_id) from auctions where test_only = 0 and consignment = 0 and created_at > :last_day"          ,
              { :last_day => Time.now - (24 * 60 * 60)} ]
  end
     
  def after_initialize
    if origin_country_id.nil?
      # default to North America and USA for country of origin for any new auction
      self.origin_region_id = Geographies::Region.find_by_name('North America').id
      self.origin_country_id = Geographies::Country.find_by_code('US').id
    end
  end
                      
  def time_to_start
    Time.at(TzTime.zone.utc_to_local(Time.now))
  end
 
  def time_to_start=(start_time_hash)
    unless date_to_start.nil?
      # take a time provided by the flextimes plugin time_select tag and
      # convert the hash (that looks like this: minute30ampmPMhour09) to Time
      # using the flextimes plugin "to_time" method
      start_time = Time.at(start_time_hash.to_time)
      # take a date provided by the Rails Date Kit date_field tag and
      # add the hour and minute parsed from the flextimes time_select tag 
      added = self.date_to_start.beginning_of_day + (start_time.hour * 3600) + (start_time.minute * 60)
      # set the date_to_start attribute which now includes the user's selected date and time 
      self.date_to_start = Time.at(TzTime.zone.local_to_utc(added))
    end
  end
  
  def time_to_end
    Time.at(TzTime.zone.utc_to_local(Time.now))
  end
 
  def time_to_end=(end_time_hash)
    unless date_to_end.nil?
      # take a time provided by the flextimes plugin time_select tag and
      # convert the hash (that looks like this: minute30ampmPMhour09) to Time
      # using the flextimes plugin "to_time" method
      end_time = Time.at(end_time_hash.to_time)
      # take a date provided by the Rails Date Kit date_field tag and
      # add the hour and minute parsed from the flextimes time_select tag 
      added = self.date_to_end.beginning_of_day + (end_time.hour * 3600) + (end_time.minute * 60)
      # set the date_to_end attribute which now includes the user's selected date and time 
      self.date_to_end = Time.at(TzTime.zone.local_to_utc(added))
    end
  end

  def time_to_pickup
    Time.at(TzTime.zone.utc_to_local(date_to_end))
  end
 
  def time_to_pickup=(end_time_hash)
    unless date_to_pickup.nil?
      # take a time provided by the flextimes plugin time_select tag and
      # convert the hash (that looks like this: minute30ampmPMhour09) to Time
      # using the flextimes plugin "to_time" method
      pickup_time = Time.at(pickup_time_hash.to_time)
      # take a date provided by the Rails Date Kit date_field tag and
      # add the hour and minute parsed from the flextimes time_select tag 
      added = self.date_to_pickup.beginning_of_day + (pickup_time.hour * 3600) + (pickup_time.minute * 60)
      # set the date_to_end attribute which now includes the user's selected date and time 
      self.date_to_pickup = Time.at(added)
    end
  end
  
  def food_root_id
    unless food_id.nil?
      Food.find(food_id).root.id
    end
  end
  
  def food_root_id=(id)
  end
  
  def food_grandparent_id
    unless food_id.nil?
      Food.find(food_id).parent.parent.id
    end
  end
  
  def food_grandparent_id=(id)
  end
  
  def food_parent_id
    unless food_id.nil?
      Food.find(food_id).parent.id
    end
  end
  
  def food_parent_id=(id)
  end
    
  def before_save
    if self.organic
      unless self.description.include?('Organic')
        self.description = "Organic #{self.description}"
      end
    end
    if self.date_last_bid.nil?
      # adjust when seller edits but not when buyer bids/purchases
      # save dates as UTC times in the database
      self.date_to_start = TzTime.zone.local_to_utc(self.date_to_start)
      self.date_to_end = TzTime.zone.local_to_utc(self.date_to_end)
      self.date_to_pickup = TzTime.zone.local_to_utc(self.date_to_pickup)
    end
    unless address_id.blank?
      address = Address.find(address_id)
      self.lat = address.lat
      self.lng = address.lng
      self.shipping_from = address.location
    end
  end
end
