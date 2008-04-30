class NewsController < ApplicationController
  
  # no access control, no need to log in or have privileges
  
  layout 'yui_t7_doc2'
  
  def index

    @active_auctions = Auction.count(
                :conditions => ["date_to_end >= ? and test_only = 0 and consignment = 0", Time.now])
    @cities = Auction.count(
                :conditions => ["date_to_end >= ? and test_only = 0 and consignment = 0", Time.now],
                :group => 'shipping_from',
                :limit => 5, 
                :order => '1 DESC')
    @products = Auction.count(
                :conditions => ["date_to_end >= ? and test_only = 0 and consignment = 0", Time.now],
                :group => 'description',
                :limit => 5, 
                :order => '1 DESC')
    respond_to do |format|
      format.html # index.rhtml
    end
  end

end
