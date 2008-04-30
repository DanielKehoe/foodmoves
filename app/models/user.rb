# == Schema Information
# Schema version: 111
#
# Table name: users
#
#  id                        :integer(11)   not null, primary key
#  of_type                   :string(255)   
#  email                     :string(255)   
#  crypted_password          :string(40)    
#  salt                      :string(40)    
#  created_at                :datetime      
#  updated_at                :datetime      
#  last_login_at             :datetime      
#  remember_token            :string(255)   
#  remember_token_expires_at :datetime      
#  visits_count              :integer(11)   default(0)
#  time_zone                 :string(255)   default("Etc/UTC")
#  permalink                 :string(255)   
#  referred_by               :string(255)   
#  parent_id                 :integer(11)   
#  invitation_code           :string(255)   
#  first_name                :string(255)   
#  last_name                 :string(255)   
#  country                   :string(255)   
#  email_confirmed           :boolean(1)    
#  children_count            :integer(11)   
#  industry_role             :string(255)   
#  region_id                 :integer(11)   
#  country_id                :integer(11)   
#  starts_as                 :string(255)   
#  first_phone               :string(255)   
#  how_heard                 :string(255)   
#  flag_for_user_id          :integer(11)   
#  invited_again_at          :datetime      
#  blocked                   :boolean(1)    
#  do_not_contact            :boolean(1)    
#

require 'digest/sha1'
class User < ActiveRecord::Base
  
  # support for single-table inheritance (use "of_type" to avoid conflict with reserved word "type")
  set_inheritance_column :of_type
  
  attr_accessor :food_grandparent_id
  attr_accessor :food_root_id
  
  # used by acl_system2 for role-based authorization control
  # (replaced by permissions model)
  # has_and_belongs_to_many :roles
  
  # more relationships
  has_many :assets, :as => :attachable
  has_many :affiliations, :dependent => :destroy
  has_many :organizations, :through => :affiliations
  has_many :bids
  has_many :watched_locations, :dependent => :destroy
  has_many :watched_products, :dependent => :destroy
  has_many :auctions
  has_many :permissions, :dependent => :destroy
  has_many :roles, :through => :permissions
  has_many :invitation_codes
  has_many :phones, :as => :phonable, :dependent => :destroy
  has_many :addresses, :as => :addressable, :dependent => :destroy
  belongs_to :flag_for_user

  # uses "parent_id" field to record a chain of invitations or referrals
  acts_as_tree :order => "created_at", :counter_cache => :children_count
  
  # from Caboose sample app
  include AuthenticatedBase
   
  # from Caboose sample app
  composed_of :tz, :class_name => 'TZInfo::Timezone', :mapping => %w( time_zone identifier )

  # from Caboose sample app
  validates_uniqueness_of :email, :on => :create, :case_sensitive => false

  # from Caboose sample app
  # Protect internal methods from mass-update with update_attributes
  # attr_accessible :of_type, :email, :password, :password_confirmation, :time_zone, 
  #  :referred_by, :invitation_code, :first_name, :last_name, :postal_code, :country, 
  # :state, :city
  
  # modified from Caboose sample app
  def to_param
    id.to_s
  end

  # modified from Caboose sample app
  def self.find_by_param(*args)
    find_by_id *args
  end

  # from Caboose sample app
  def to_xml
    super( :only => [ :email, :time_zone, :last_login_at ] )
  end

  # sometimes we need a list of all the types of Users
  def self.user_types
    ['Guest', 'Member', 'Administrator']
  end

  def admin?
    false
    if self.of_type == 'Administrator' then true end
  end

  # To accomodate the "has many through" association with BluebookMember (via Affiliations)
  # we have to provide a method to generate the role_ids. This is provided automatically
  # with "has and belongs to many" associations but must be provided for "has many through" 
  # associations. If we don't provide this, we'll get an error "undefined method role_ids"
  # when we try to use a check_box tag.
  def bluebook_member_ids=(bluebook_member_ids)  	   	
    affiliations.each do |affiliation| 	  	
      affiliation.destroy unless bluebook_member_ids.include? affiliation.bluebook_id 	  	
    end 	  	
 	
    bluebook_ids.each do |bluebook_member_id| 	  	
      self.affiliations.create(:bluebook_member_id => bluebook_member_id)unless affiliations.any? { |d| d.bluebook_member_id == bluebook_member_id } 	  	
    end 	  	
  end
    
  # To accomodate the "has many through" association with Role (via Permissions)
  # we have to provide a method to generate the role_ids. This is provided automatically
  # with "has and belongs to many" associations but must be provided for "has many through" 
  # associations. If we don't provide this, we'll get an error "undefined method role_ids"
  # when we try to use a check_box tag.
  def role_ids=(role_ids)  	   	
    permissions.each do |permission| 	  	
      permission.destroy unless role_ids.include? permission.role_id 	  	
    end 	  	
 	
    role_ids.each do |role_id| 	  	
      self.permissions.create(:role_id => role_id)unless permissions.any? { |d| d.role_id == role_id } 	  	
    end 	  	
  end
  
  def after_initialize
    if country_id.nil?
      # default to North America and USA for any new user
      self.region_id = Geographies::Region.find_by_name('North America').id
      self.country_id = Geographies::Country.find_by_code('US').id
    end
  end
  
  # It's important to remember that the User "before_save" doesn't get called 
  # when a subclass is saved.
  def before_save
    unless industry_role.blank?
      self.starts_as = IndustryRole.find_by_answer(industry_role).description
    else
      self.starts_as = 'other'
    end
    unless country_id.nil? 
      self.country = Geographies::Country.find(country_id).code.upcase
    end
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
    unless first_phone.nil? 
      self.first_phone = first_phone.strip
      self.first_phone = first_phone.squeeze(' ')
      self.first_phone = first_phone.tr('(', '')
      self.first_phone = first_phone.tr(')', '')
      unless self.first_phone.index(' ') == 3
        self.first_phone = first_phone.squeeze(' ')
      end
      self.first_phone = first_phone.tr('.', ' ')
      self.first_phone = first_phone.tr('-', ' ')
      unless self.first_phone.index('+') == 0
        self.first_phone = "+1 #{self[:first_phone]}"
      end
    end
  end

  # It's important to remember that the User "after_save" doesn't get called 
  # when a subclass is saved.
  def after_save
  end
    
  def name
    unless last_name.blank?
      if blocked 
        "#{first_name} #{last_name} (*)"
      elsif do_not_contact
        "DO NOT CONTACT #{first_name} #{last_name}"
      else
        "#{first_name} #{last_name}"
      end
    else
      email
    end
  end
  
  def name_reversed
    unless last_name.blank?
      "#{last_name}, #{first_name}"
    else
      email
    end
  end

  def region
    unless region_id.nil?
      Geographies::Region.find(region_id).name
    else
      'North America'
    end
  end
    
  def country_code
    unless country_id.nil?
      Geographies::Country.find(country_id).code.upcase
    else
      'US'
    end
  end

  def country
    country_code
  end

  def country_name
    unless country_id.nil?
      Geographies::Country.find(country_id).name
    else
      'USA'
    end
  end

  def email
    if do_not_contact 
      'DO NOT CONTACT'
    else
      self[:email]
    end
  end

  def first_phone
    if do_not_contact 
      'DO NOT CONTACT'
    else
      self[:first_phone]
    end
  end
  
  def self.count_all
    count()
  end

  def self.count_all_nixies
    count(:conditions => "of_type = 'Guest' and email_confirmed IS NULL ")
  end
  
  def self.count_all_guests
    count(:conditions => "of_type = 'Guest' and email_confirmed = 1")
  end

  def self.count_all_members
    count(:conditions => "of_type = 'Member'")
  end

  def self.count_all_sellers
    count(:conditions => "of_type = 'Member' and starts_as = 'seller'")
  end
 
  def self.count_all_buyers
    count(:conditions => "of_type = 'Member' and starts_as = 'buyer'")
  end
  
  def self.count_all_members_logins_last_day
    count(:conditions => ["of_type = 'Member' and last_login_at > :last_day",
              { :last_day => Time.now - (24 * 60 * 60)} ])
  end

  def self.count_all_sellers_logins_last_day
    count(:conditions => ["of_type = 'Member' and starts_as = 'seller' and last_login_at > :last_day",
              { :last_day => Time.now - (24 * 60 * 60)} ])
  end
 
  def self.count_all_buyers_logins_last_day
    count(:conditions => ["of_type = 'Member' and starts_as = 'buyer' and last_login_at > :last_day",
              { :last_day => Time.now - (24 * 60 * 60)} ])
  end

  def self.count_all_members_logins_last_72_hrs
    count(:conditions => ["of_type = 'Member' and last_login_at > :last_day",
              { :last_day => Time.now - (72 * 60 * 60)} ])
  end

  def self.count_all_sellers_logins_last_72_hrs
    count(:conditions => ["of_type = 'Member' and starts_as = 'seller' and last_login_at > :last_day",
              { :last_day => Time.now - (72 * 60 * 60)} ])
  end
 
  def self.count_all_buyers_logins_last_72_hrs
    count(:conditions => ["of_type = 'Member' and starts_as = 'buyer' and last_login_at > :last_day",
              { :last_day => Time.now - (72 * 60 * 60)} ])
  end
      
  def self.count_all_last_7_days
    count(:conditions => ["created_at > :last_week",
              { :last_week => Time.now - (7 * 24 * 60 * 60)} ])
  end
      
  def self.count_nixies_last_7_days
    count(:conditions => ["of_type = 'Guest' and email_confirmed IS NULL and created_at > :last_week",
              { :last_week => Time.now - (7 * 24 * 60 * 60)} ])
  end

  def self.count_guests_last_7_days
    count(:conditions => ["of_type = 'Guest' and email_confirmed = 1 and created_at > :last_week",
              { :last_week => Time.now - (7 * 24 * 60 * 60)} ])
  end

  def self.count_members_last_7_days
    count(:conditions => ["of_type = 'Member' and created_at > :last_week",
              { :last_week => Time.now - (7 * 24 * 60 * 60)} ])
  end

  def self.count_all_last_day
    count(:conditions => ["created_at > :last_day",
              { :last_day => Time.now - (24 * 60 * 60)} ])
  end
      
  def self.count_nixies_last_day
    count(:conditions => ["of_type = 'Guest' and email_confirmed IS NULL and created_at > :last_day",
              { :last_day => Time.now - (24 * 60 * 60)} ])
  end

  def self.count_guests_last_day
    count(:conditions => ["of_type = 'Guest' and email_confirmed = 1 and created_at > :last_day",
              { :last_day => Time.now - (24 * 60 * 60)} ])
  end

  def self.count_members_last_day
    count(:conditions => ["of_type = 'Member' and created_at > :last_day",
              { :last_day => Time.now - (24 * 60 * 60)} ])
  end

  def self.all_count_0days_ago
    count(:conditions => ["created_at "  +
      "#{((Time.now.beginning_of_day - 7.hours)..(Time.now)).to_s(:db)}"])
  end
  
  def self.all_count_1days_ago
    count(:conditions => ["created_at "  +
      "#{((1.days.ago.beginning_of_day - 7.hours)..(Time.now.beginning_of_day - 7.hours)).to_s(:db)}"])
  end
  
  def self.all_count_2days_ago
    count(:conditions => ["created_at "  +
      "#{((2.days.ago.beginning_of_day - 7.hours)..(1.day.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.all_count_3days_ago
    count(:conditions => ["created_at "  +
      "#{((3.days.ago.beginning_of_day - 7.hours)..(2.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end 

  def self.all_count_4days_ago
    count(:conditions => ["created_at "  +
      "#{((4.days.ago.beginning_of_day - 7.hours)..(3.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.all_count_5days_ago
    count(:conditions => ["created_at "  +
      "#{((5.days.ago.beginning_of_day - 7.hours)..(4.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.all_count_6days_ago
    count(:conditions => ["created_at "  +
      "#{((6.days.ago.beginning_of_day - 7.hours)..(5.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.all_count_7days_ago
    count(:conditions => ["created_at "  +
      "#{((7.days.ago.beginning_of_day - 7.hours)..(6.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.all_count_8days_ago
    count(:conditions => ["created_at "  +
      "#{((8.days.ago.beginning_of_day - 7.hours)..(7.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end
  
  def self.nixies_count_2days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed IS NULL and created_at "  +
      "#{((2.days.ago.beginning_of_day - 7.hours)..(1.day.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.nixies_count_0days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed IS NULL and created_at "  +
      "#{((Time.now.beginning_of_day - 7.hours)..(Time.now)).to_s(:db)}"])
  end
  
  def self.nixies_count_1days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed IS NULL and created_at "  +
      "#{((1.days.ago.beginning_of_day - 7.hours)..(Time.now.beginning_of_day - 7.hours)).to_s(:db)}"])
  end
  
  def self.nixies_count_3days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed IS NULL and created_at "  +
      "#{((3.days.ago.beginning_of_day - 7.hours)..(2.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end 

  def self.nixies_count_4days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed IS NULL and created_at "  +
      "#{((4.days.ago.beginning_of_day - 7.hours)..(3.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.nixies_count_5days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed IS NULL and created_at "  +
      "#{((5.days.ago.beginning_of_day - 7.hours)..(4.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.nixies_count_6days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed IS NULL and created_at "  +
      "#{((6.days.ago.beginning_of_day - 7.hours)..(5.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.nixies_count_7days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed IS NULL and created_at "  +
      "#{((7.days.ago.beginning_of_day - 7.hours)..(6.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.nixies_count_8days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed IS NULL and created_at "  +
      "#{((8.days.ago.beginning_of_day - 7.hours)..(7.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.guests_count_0days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed = 1 and created_at "  +
      "#{((Time.now.beginning_of_day - 7.hours)..(Time.now)).to_s(:db)}"])
  end
  
  def self.guests_count_1days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed = 1 and created_at "  +
      "#{((1.days.ago.beginning_of_day - 7.hours)..(Time.now.beginning_of_day - 7.hours)).to_s(:db)}"])
  end
    
  def self.guests_count_2days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed = 1 and created_at "  +
      "#{((2.days.ago.beginning_of_day - 7.hours)..(1.day.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.guests_count_3days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed = 1 and created_at "  +
      "#{((3.days.ago.beginning_of_day - 7.hours)..(2.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end 

  def self.guests_count_4days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed = 1 and created_at "  +
      "#{((4.days.ago.beginning_of_day - 7.hours)..(3.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.guests_count_5days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed = 1 and created_at "  +
      "#{((5.days.ago.beginning_of_day - 7.hours)..(4.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.guests_count_6days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed = 1 and created_at "  +
      "#{((6.days.ago.beginning_of_day - 7.hours)..(5.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.guests_count_7days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed = 1 and created_at "  +
      "#{((7.days.ago.beginning_of_day - 7.hours)..(6.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.guests_count_8days_ago
    count(:conditions => ["of_type = 'Guest' and email_confirmed = 1 and created_at "  +
      "#{((8.days.ago.beginning_of_day - 7.hours)..(7.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.members_count_0days_ago
    count(:conditions => ["of_type = 'Member' and created_at "  +
      "#{((Time.now.beginning_of_day - 7.hours)..(Time.now)).to_s(:db)}"])
  end
  
  def self.members_count_1days_ago
    count(:conditions => ["of_type = 'Member' and created_at "  +
      "#{((1.days.ago.beginning_of_day - 7.hours)..(Time.now.beginning_of_day - 7.hours)).to_s(:db)}"])
  end
    
  def self.members_count_2days_ago
    count(:conditions => ["of_type = 'Member' and created_at "  +
      "#{((2.days.ago.beginning_of_day - 7.hours)..(1.day.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.members_count_3days_ago
    count(:conditions => ["of_type = 'Member' and created_at "  +
      "#{((3.days.ago.beginning_of_day - 7.hours)..(2.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end 
  
  def self.members_count_4days_ago
    count(:conditions => ["of_type = 'Member' and created_at "  +
      "#{((4.days.ago.beginning_of_day - 7.hours)..(3.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.members_count_5days_ago
    count(:conditions => ["of_type = 'Member' and created_at "  +
      "#{((5.days.ago.beginning_of_day - 7.hours)..(4.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end
  
  def self.members_count_6days_ago
    count(:conditions => ["of_type = 'Member' and created_at "  +
      "#{((6.days.ago.beginning_of_day - 7.hours)..(5.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.members_count_7days_ago
    count(:conditions => ["of_type = 'Member' and created_at "  +
      "#{((7.days.ago.beginning_of_day - 7.hours)..(6.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end

  def self.members_count_8days_ago
    count(:conditions => ["of_type = 'Member' and created_at "  +
      "#{((8.days.ago.beginning_of_day - 7.hours)..(7.days.ago.beginning_of_day - 7.hours)).to_s(:db)}"])
  end
  
  def self.spamming_invitations?(user)
    false
    invites_sent = count :conditions => ["parent_id = :id and created_at > :since",
                        { :id => user, :since => Time.now - 15.minutes } ]
    if invites_sent > 12 then true end
  end
  
  def self.spamming_reinvitations?(user)
    false
    invites_sent = count :conditions => ["parent_id = :id and invited_again_at > :since",
                        { :id => user, :since => Time.now - 15.minutes } ]
    if invites_sent > 12 then true end
  end
  
  def self.ignored_spamming_invitations_alert?(user)
    false
    invites_sent = count :conditions => ["parent_id = :id and created_at > :since",
                        { :id => user, :since => Time.now - 15.minutes } ]
    if invites_sent > 13 then true end
  end
  
  def self.ignored_spamming_reinvitations_alert?(user)
    false
    invites_sent = count :conditions => ["parent_id = :id and invited_again_at > :since",
                        { :id => user, :since => Time.now - 15.minutes } ]
    if invites_sent > 13 then true end
  end
end
