class SellController < ApplicationController

  layout 'sell'
  
  before_filter :login_required
  
  def index
    if logged_in?
      if permit?('guest')
        flash.now[:notice] = "Your account is not affiliated with a company. " +
          "You can browse but you cannot buy or sell. " +
          "Would you like to <a href=\"/members/new\">set up trading?</a>"
      end      
      # current auctions
      current_count = Auction.count :conditions => ["seller_id = :id and date_to_end >= :now",
        { :id => @current_user.id, :now => Time.now } ]
      if current_count == 0 then
        @no_current_auctions = true
      else
        @current_pager = ::Paginator.new(Auction.count, 10) do |offset, per_page|
          Auction.find(:all, 
                        :limit => per_page, 
                        :offset => offset, 
                        :conditions => ["seller_id = :id and date_to_end >= :now",
                          { :id => @current_user.id, :now => Time.now } ],
                        :order => "date_to_end ASC")
        end
        @current_page = @current_pager.page(params[:page])
      end
      # completed auctions
      completed_count = Auction.count :conditions => ["seller_id = :id and date_to_end < :now",
        { :id => @current_user.id, :now => Time.now } ]
      if completed_count == 0 then
        @no_completed_auctions = true
      else
        @completed_pager = ::Paginator.new(Auction.count, 10) do |offset, per_page|
          Auction.find(:all, 
                        :limit => per_page, 
                        :offset => offset, 
                        :conditions => ["seller_id = :id and date_to_end < :now",
                          { :id => @current_user.id, :now => Time.now } ],
                        :order => "date_to_end DESC")
        end
        @completed_page = @completed_pager.page(params[:page])
      end
    else
      @no_completed_auctions = true
      @no_current_auctions = true
    end
    @top_prices = Auction.find(:all,
                    :conditions => "buyer_id IS NOT NULL", 
                    :limit => 5,
                    :order => "current_bid DESC, description ASC")               
    respond_to do |format|
      format.html # index.rhtml
    end
  end
  
end
