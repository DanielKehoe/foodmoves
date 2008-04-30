# == Schema Information
# Schema version: 111
#
# Table name: bids
#
#  id             :integer(11)   not null, primary key
#  closed         :boolean(1)    
#  winner         :boolean(1)    
#  user_id        :integer(11)   
#  auction_id     :integer(11)   
#  created_at     :datetime      
#  updated_at     :datetime      
#  closed_at      :datetime      
#  amount         :decimal(10, 2 default(0.0)
#  quantity       :integer(11)   default(0)
#  date_to_end    :datetime      
#  date_to_pickup :datetime      
#  buy_now_sale   :boolean(1)    
#

class Bid < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :auction

  def self.count_bidders_last_day
    count_by_sql(["select count(distinct user_id) from bids where amount > 0 and created_at > :last_day"          ,
              { :last_day => Time.now - (24 * 60 * 60)} ])
  end
  
  def self.count_all_current
    count(:conditions => ["closed = 0 and amount > 0 and date_to_end > :now",
                    { :now => Time.now } ])
  end
    
  def self.find_all_current(user_id)
    find(:all,
          :conditions => ["user_id = :id and closed = 0 and amount > 0 and date_to_end > :now",
                    { :id => user_id, :now => Time.now } ],
          :order => "date_to_end ASC")
  end
  
  def self.find_in_basket(user_id)
    find(:all,
          :conditions => ["user_id = :id and closed = 0 and amount = 0 and date_to_end > :now",
                    { :id => user_id, :now => Time.now } ],
          :order => "created_at DESC")
  end

  def self.find_purchases(user_id)
    find(:all,
          :conditions => ["user_id = :id and closed = 1 and winner = 1",
                    { :id => user_id, :now => Time.now } ],
          :order => "closed_at DESC")
  end

  def self.find_pending_pickups(user_id)
    find(:all,
          :conditions => ["user_id = :id and closed = 1 and winner = 1 and date_to_pickup > :now",
                    { :id => user_id, :now => Time.now } ],
          :order => "closed_at DESC")
  end
    
  def self.current_bidding_includes?(user_id, auction_id)
    find(:first,
          :conditions => ["auction_id = :auction_id and user_id = :id and closed = 0 and amount > 0 and date_to_end > :now",
                    { :auction_id => auction_id, :id => user_id, :now => Time.now } ])
  end
  
  def self.basket_includes?(user_id, auction_id)
    find(:first,
          :conditions => ["auction_id = :auction_id and user_id = :id and closed = 0 and amount = 0 and date_to_end > :now",
                    { :auction_id => auction_id, :id => user_id, :now => Time.now } ])
  end
   
  def self.all_current(user_id)
    bids_in_basket = find_all_current(user_id)
    auctions = bids_in_basket.map { |bid| bid.auction }
    bids_in_basket.zip(auctions)
  end
   
  def self.basket(user_id)
    bids_in_basket = find_in_basket(user_id)
    auctions = bids_in_basket.map { |bid| bid.auction }
    bids_in_basket.zip(auctions)
  end
 
  def self.purchases(user_id)
    bids_won = find_purchases(user_id)
    auctions = bids_won.map { |bid| bid.auction }
    bids_won.zip(auctions)
  end
  
  def self.pending_pickups(user_id)
    bids_won = find_pending_pickups(user_id)
    auctions = bids_won.map { |bid| bid.auction }
    bids_won.zip(auctions)
  end
end
