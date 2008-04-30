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

class Invoice < Auction
 
  def self.find_all_invoices
    find(:all,
          :conditions => "due_foodmoves > 0",
          :order => "id DESC")
  end
   
  def self.find_invoices_to_mail
    find(:all,
          :conditions => "due_foodmoves > 0 and bill_me = 1 and date_billed IS NULL",
          :order => "id DESC")
  end
  
  def self.find_invoices_for_cc
    find(:all,
          :conditions => "due_foodmoves > 0 and bill_me = 0 and date_billed IS NULL",
          :order => "id DESC")
  end
  
  def self.find_open_invoices
    find(:all,
          :conditions => "due_foodmoves > 0 and date_billed IS NOT NULL and date_paid IS NULL",
          :order => "id DESC")
  end
  
  def self.find_paid_invoices
    find(:all,
          :conditions => "due_foodmoves > 0 and date_paid IS NOT NULL",
          :order => "id DESC")
  end
end
