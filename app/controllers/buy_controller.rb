class BuyController < ApplicationController

  layout 'buy'
  
  before_filter :login_required
  
  auto_complete_for :buy, :query

  def index
    if logged_in?
      if permit?('guest')
        flash.now[:notice] = "Your account is not affiliated with a company. " +
          "You can browse but you cannot buy or sell. " +
          "Would you like to <a href=\"/members/new\">set up trading?</a>"
      end
    end
    @no_bids = true
    @watched_products = Array.new
    @watched_locations = Array.new
    @current_bids = Array.new
    if logged_in?
      for product in @current_user.watched_products
        product.auctions = Auction.count :conditions => ["description like :query 
          and date_to_end >= :now", { :query => "%"+product.description+"%", :now => Time.now } ]
        product.bids = Auction.sum :how_many_bids, :conditions => ["description like :query 
          and date_to_end >= :now", { :query => "%"+product.description+"%", :now => Time.now } ]
        product.low = Auction.minimum :minimum_bid, :conditions => ["description like :query 
          and date_to_end >= :now", { :query => "%"+product.description+"%", :now => Time.now } ]
        product.high = Auction.maximum :current_bid, :conditions => ["description like :query 
          and date_to_end >= :now", { :query => "%"+product.description+"%", :now => Time.now } ]
        @watched_products << product
      end
      for location in @current_user.watched_locations
        location.auctions = Auction.count :conditions => ["shipping_from like :query 
          and date_to_end >= :now", { :query => "%"+location.name+"%", :now => Time.now } ]
        @watched_locations << location
      end
      @current_bids = Bid.all_current(@current_user.id)
    end
    @auctions = Auction.find :all,
                  :conditions => ["date_to_end >= :now and consignment = 0 ",
                      { :now => Time.now } ],
                  :order => 'date_to_end ASC'
    if @fail
      flash[:error] = @err_msg
      redirect_to :back
    else
      respond_to do |format|
        format.html # index.rhtml
      end
    end
  end

  def search_for_product
    unless logged_in?
        flash[:notice] = "Please log in if you'd like to search for products."
        redirect_to alerts_path and return
    else
      @search = Buy.new(params[:buy])
      @search.show_map = false
      unless params[:id].nil?
        food = Food.find(params[:id])
        @search.query = food.name
      end
      if @search.query.blank?
        @no_current_auctions = true
      else
        current_count = Auction.count :conditions => ["description like :query and date_to_end >= :now",
            { :query => "%"+@search.query+"%", :now => Time.now } ] 
        if current_count == 0 then
          @no_current_auctions = true
        else
          # not searching by location, so find all that match the query and sort by ending date
          @auctions = Auction.find :all,
                        :limit => 100,
                        :conditions => ["description like :query and date_to_end >= :now",
                            { :query => "%"+@search.query+"%", :now => Time.now } ],
                        :order => "date_to_end DESC"
          markers = Array.new
          @auctions.each_with_index do |auction, i|
            info_window = []
            info_window << "<strong><a href=\"/auctions/#{auction.id}\">#{auction.description}</a></strong>"
            info_window << "(#{auction.shipping_from})"   
            # TO DO: the code to offset display of markers needs improvement
            markers << GMarker.new([auction.lat + (i * 0.0005), auction.lng + (i * -0.0005)],
                        :info_window => info_window.join("<br />\n"), 
                        :title => auction.description)
          end
          clusterer = Clusterer.new(markers)
          # use the YM4R/GM plugin to generate a map
          @map = GMap.new("mini_map")
          @map.control_init(:large_map => true) 
          sorted_latitudes = @auctions.collect(&:lat).compact.sort
          sorted_longitudes = @auctions.collect(&:lng).compact.sort
          @map.center_zoom_on_bounds_init([
          	[sorted_latitudes.first, sorted_longitudes.first],
          	[sorted_latitudes.last, sorted_longitudes.last]])
          @map.overlay_init(clusterer)
        end
      end
    end
    if @fail
      flash[:error] = @err_msg
      redirect_to :back
    else
      respond_to do |format|
        format.html { render :template => 'buy/search', 
                            :layout => 'buy' } # search.rhtm
      end
    end
  end

  def search_by_location
    @search = Buy.new(params[:buy])
    unless params[:id].nil?
      @search.show_map = true
      watched_location = WatchedLocation.find(params[:id])
      if watched_location.lat? && watched_location.lng?
        # find up to 100 auctions within 100 miles (or km?)
        # TO DO: use defaults for number of auctions and distance
        @auctions = Auction.find(:all, 
                      :origin => watched_location, 
                      :limit => 100, 
                      :conditions => ["distance < :specified and date_to_end >= :now and closed != 1",
                          { :specified => 400, :now => Time.now } ],
                      :order => "distance ASC")
        markers = Array.new
        @auctions.each_with_index do |auction, i|
          info_window = []
          info_window << "<strong><a href=\"/auctions/#{auction.id}\">#{auction.description}</a></strong>"
          info_window << "(#{auction.shipping_from})"
          # TO DO: the code to offset display of markers needs improvement
          markers << GMarker.new([auction.lat + (i * 0.0005), auction.lng + (i * -0.0005)],
                      :info_window => info_window.join("<br />\n"), 
                      :title => auction.description)
        end
        clusterer = Clusterer.new(markers)
        # use the YM4R/GM plugin to generate a map
        @map = GMap.new("mini_map")
        @map.control_init(:large_map => true) 
        @map.center_zoom_init([watched_location.lat,watched_location.lng],8)
        @map.overlay_init(clusterer)
      else
        flash.now[:notice] = "No latitude/longitude found for watched location."
      end    
    end
    respond_to do |format|
      format.html { render :template => 'buy/search', 
                          :layout => 'buy' } # search.rhtml
    end
  end

  def search_nearby
    @search = Buy.new(params[:buy])
    unless params[:id].nil?
      @search.show_map = true
      auction_location = Auction.find(params[:id])
      if auction_location.lat? && auction_location.lng?
        # find up to 100 auctions within 100 miles (or km?)
        # TO DO: use defaults for number of auctions and distance
        @auctions = Auction.find(:all, 
                      :origin => auction_location, 
                      :limit => 100, 
                      :conditions => ["distance < :specified and date_to_end >= :now and closed != 1",
                          { :specified => 400, :now => Time.now } ],
                      :order => "distance ASC")
        markers = Array.new
        @auctions.each_with_index do |auction, i|
          info_window = []
          info_window << "<strong><a href=\"/auctions/#{auction.id}\">#{auction.description}</a></strong>"
          info_window << "(#{auction.shipping_from})"
          # TO DO: the code to offset display of markers needs improvement
          markers << GMarker.new([auction.lat + (i * 0.0005), auction.lng + (i * -0.0005)],
                      :info_window => info_window.join("<br />\n"), 
                      :title => auction.description)
        end
        clusterer = Clusterer.new(markers)
        # use the YM4R/GM plugin to generate a map
        @map = GMap.new("mini_map")
        @map.control_init(:large_map => true) 
        sorted_latitudes = @auctions.collect(&:lat).compact.sort
        sorted_longitudes = @auctions.collect(&:lng).compact.sort
        @map.center_zoom_init([auction_location.lat,auction_location.lng],7)
        @map.overlay_init(clusterer)
      else
        flash.now[:notice] = "No latitude/longitude found for this item."
      end    
    end
    respond_to do |format|
      format.html { render :template => 'buy/search', 
                          :layout => 'buy' } # search.rhtml
    end
  end

  def add_to_watchlist
    @buy = Buy.new(params[:buy])
    logger.info { "\n\n query is #{@buy.query} \n\n" }
    @food = Food.find_by_name(@buy.query)
    logger.info { "\n\n food name is #{@food.name} \n\n" }
    logger.info { "\n\n food id is #{@food.id} \n\n" }
    @watched_item = WatchedProduct.new(:user_id => @current_user.id,
                                        :description => @buy.query,
                                        :food_id => @food.id) 
    @current_user.watched_products << @watched_item
    if @current_user.save
      flash.now[:notice] = "You will receive email alerts about auctions for \"#{@watched_item.description}\""
    else
      flash.now[:notice] = "Unable to create email alert about auctions for \"#{@watched_item.description}\""
    end
    redirect_to buy_path
  end
    
  def delete_from_watchlist
    @watched_item = WatchedProduct.find(params[:id])
    name = @watched_item.description.nil? ? 'Item' : @watched_item.description
    @current_user.watched_products.delete(@watched_item)
    respond_to do |format|
      flash[:notice] = "Successfully deleted \"#{name}\" from email alerts."
      format.html { redirect_to buy_path }
      format.xml  { head :ok }
    end
  end 
  
  def autocomplete_query
    # block errors generated by a googlebot visitor
    return render :nothing => true, :status => 403 unless logged_in? 
    @foods = Food.find(:all,
                  :conditions => ["name like :query",
                      { :query => "%"+params[:buy][:query]+"%" } ],
                  :order => "name")
    render :layout => false
  end
  private
  
  # set the failure flag and set an error message
  def failure(err_msg)
    @fail = true
    @err_msg = err_msg
  end  
end
