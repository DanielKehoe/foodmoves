class BidsController < ApplicationController
  
  layout "admin"

  # from acl_system2 example
  before_filter :login_required
  access_control [:show, :new, :create, :update, :destroy] => 'member',
                  [:index, :edit] => '(admin | manager | support)'
  
  # GET /bids
  # GET /bids.xml
  def index
    @bids = Bid.paginate :per_page => 20, 
                                  :page => params[:page],
                                  :conditions => ['closed = 0 and amount > 0'],
                                  :order => 'date_to_end DESC, updated_at DESC'
    @basket = Bid.paginate :per_page => 20, 
                                  :page => params[:page],
                                  :conditions => ['closed = 0 and amount = 0'],
                                  :order => 'date_to_end DESC, updated_at DESC'
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @bids.to_xml }
    end
  end

  # GET /bids/1
  # GET /bids/1.xml
  def show
    @bid = Bid.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @bid.to_xml }
    end
  end

  # GET /bids/new
  def new
    restrict_to "member" do
      unless @current_user.affiliations.first.approved_to_buy
        raise Exception, "When you were set up for trading, your company did not authorize you to buy."
      end
      exists = Bid.find_by_user_id_and_auction_id(@current_user.id, params[:id])
      if exists
        if exists.amount.nil?
          raise Exception, "It's already in your bid basket."
        else
          if exists.amount > 0
            if exists.buy_now_sale == true
              raise Exception, "You've already purchased that."
            else
              raise Exception, "Would you like to increase your bid?"
            end
          else
            raise Exception, "It's already in your bid basket."
          end
        end
      else
        auction = Auction.find(params[:id])
        if auction.closed
          raise Exception, "No bids can be accepted. The auction is closed."
        end
        if auction.excessive_risk?(@current_user)
          raise Exception, "Your company's financial profile does not meet the seller's minimum requirements."
        end
        unless params[:bid].nil?
          if params[:bid][:amount].blank?
            raise Exception, "You did not enter a bid amount."
          end
        else
          raise Exception, "Error in processing bid."
        end
        @bid = Bid.new(params[:bid])
        @bid.user_id = @current_user.id
        @bid.auction_id = auction.id
        @bid.date_to_end = auction.date_to_end
        @bid.date_to_pickup = auction.date_to_pickup
        @bid.quantity = auction.quantity #temporary until we implement partial quantities
        unless (@bid.amount == auction.buy_now_price) and (auction.buy_now_price > 0) and (auction.how_many_bids == 0)
          if @current_user.id == auction.seller_id
            raise Exception, "You are not allowed to bid on your own auction."
          else
            unless @bid.amount >= auction.minimum_bid
              raise Exception, "Your bid must be greater than the $#{auction.minimum_bid} minimum bid."
            else
              unless @bid.amount >= auction.current_bid + auction.bid_increment
                raise Exception, "Your bid must be greater than $#{auction.current_bid + auction.bid_increment}."
              else
                if auction.how_many_bids.nil?
                  auction.how_many_bids = 1
                else 
                  if auction.how_many_bids == 0
                    auction.how_many_bids = 1
                  else
                    auction.how_many_bids = auction.how_many_bids + 1
                    unless auction.last_bid_id.nil?
                      old_bid = Bid.find(auction.last_bid_id)
                    end
                  end
                end
                auction.date_last_bid = Time.now
                auction.current_bid = @bid.amount    
                begin
                  @bid.save
                rescue
                  raise Exception, "Unable to enter bid. Could not save bid data."
                end
                begin
                  auction.last_bid_id = @bid.id
                  auction.save
                rescue
                  raise Exception, "Unable to enter bid. Could not save auction data."
                end
                begin
                  AuctionMailer::deliver_notify_bid_was_accepted(auction, @bid)
                  unless old_bid.nil?
                    unless old_bid.user_id == @current_user.id
                      AuctionMailer::deliver_notify_bidder_was_outbid(auction, old_bid)
                    end
                  end
                rescue
                  raise Exception, "Bid entered but unable to send email notification to " +
                    "bidder or any previous bidder."
                end
                flash[:notice] = "Entered a new bid for #{auction.description}."
                chat_alert('team', "user #{@current_user.name} " +
                      "bid on #{auction.description}")
                chat_alert('user', "new bid of #{@bid.amount} for #{auction.description}")
              end
            end
          end
        else
          # this is a BUY IT NOW transaction
          @bid.buy_now_sale = true
          @bid.closed = true
          @bid.winner = true
          @bid.closed_at = Time.now
          @bid.quantity = auction.quantity
          auction.how_many_bids = 1
          auction.date_to_end = auction.date_last_bid = @bid.closed_at
          auction.current_bid = @bid.amount
          auction.closed = true
          auction.buyer_id = @current_user.id
          begin
            @bid.save
          rescue
            raise Exception, "Unable to complete \"It's Yours\" purchase. Could not save bid data."
          end
          auction.due_foodmoves = money_for_us(auction)
          auction.sale_total = auction.current_bid * auction.quantity
          begin
            auction.save
          rescue
            raise Exception, "Unable to complete \"It's Yours\" purchase. Could not save auction data."
          end
          begin
            AuctionMailer::deliver_notify_seller_of_buynow_sale(auction, @bid)
            AuctionMailer::deliver_notify_buyer_of_buynow_sale(auction, @bid)
          rescue
            raise Exception, "Purchase completed but unable to send email notification to buyer or seller."
          end
          begin
            charge_the_seller(auction, @bid)
          rescue Exception => e
            logger.info "\n\n#{Time.now}: #{e}\n\n"
          end
          unless @fail 
            flash[:notice] = "Congratulations. You've purchased #{auction.description}. " +
              "Check your email for details."
              chat_alert('team', "user #{@current_user.name} " +
                    "purchased #{auction.description} at #{@bid.amount}")
              chat_alert('user', "a user purchased #{auction.description} at #{@bid.amount}")
          end
        end
      end
      unless @fail
        if @bid.buy_now_sale
          redirect_to member_path(@current_user) 
        else
          redirect_to buy_path 
        end
      else
        flash[:error] = @err_msg
        redirect_to :back
      end
    end
  rescue Exception => e
    flash[:error] = "#{e}"
    redirect_to :back
  end

  # GET /bids/1;edit
  def edit
    @bid = Bid.find(params[:id])
  end

  # POST /bids
  # POST /bids.xml
  def create
    @bid = Bid.new(params[:bid])
    respond_to do |format|
      if @bid.save
        flash[:notice] = 'Bid was successfully created.'
        format.html { redirect_to bid_url(@bid) }
        format.xml  { head :created, :location => bid_url(@bid) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bid.errors.to_xml }
      end
    end
  end

  # PUT /bids/1
  # PUT /bids/1.xml
  # the user is increasing the bid amount
  def update
    restrict_to "member" do
      unless @current_user.affiliations.first.approved_to_buy
        raise Exception, "When you were set up for trading, your company did not authorize you to buy."
      end
      @bid = Bid.find_by_user_id_and_auction_id(@current_user.id, params[:id])
      if @bid.closed
        if @bid.buy_now_sale == true
          raise Exception, "It was already purchased."
        else
          raise Exception, "Bidding is closed."
        end
      else
        auction = Auction.find(params[:id])
        if auction.closed
          raise Exception, "No bids can be accepted. The auction is closed."
        end
        if auction.excessive_risk?(@current_user)
          raise Exception, "Your company's financial profile does not meet the seller's minimum requirements."
        end
        if params[:bid].nil?
          raise Exception, "Error in processing bid."
        else
          if params[:bid][:amount].blank?
            raise Exception, "You did not enter a bid amount."
          end
          @bid.amount = params[:bid][:amount]
          unless @bid.amount >= auction.minimum_bid
            raise Exception, "Your bid must be greater than the $#{auction.minimum_bid} minimum bid."
          else
            unless @bid.amount >= auction.current_bid + auction.bid_increment
              raise Exception, "Your bid must be greater than $#{auction.current_bid + auction.bid_increment}."
            else
              if auction.how_many_bids.nil?
                auction.how_many_bids = 1
              else 
                if auction.how_many_bids == 0
                  auction.how_many_bids = 1
                else
                  auction.how_many_bids = auction.how_many_bids + 1
                  old_bid = Bid.find(auction.last_bid_id)
                end
              end
              auction.date_last_bid = Time.now
              auction.current_bid = @bid.amount
              begin
                @bid.save
              rescue
                raise Exception, "Unable to enter bid. Could not save bid data."
              end
              begin
                auction.last_bid_id = @bid.id
                auction.save
              rescue
                raise Exception, "Unable to enter bid. Could not save auction data."
              end
              begin
                AuctionMailer::deliver_notify_bid_was_accepted(auction, @bid)
                unless old_bid.nil?
                  unless old_bid.user_id == @current_user.id
                    AuctionMailer::deliver_notify_bidder_was_outbid(auction, old_bid)
                  end
                end
              rescue
                raise Exception, "Bid entered but unable to send email notification to " +
                  "bidder or any previous bidder."
              end
              unless @fail 
                flash[:notice] = "Entered a new bid for #{auction.description}."
                chat_alert('team', "user #{@current_user.name} " +
                      "bid on #{auction.description}")
                chat_alert('user', "new bid of #{@bid.amount} for #{auction.description}")
              end
            end        
          end
        end
      end
      unless @fail
        redirect_to buy_path
      else
        flash[:error] = @err_msg
        redirect_to :back
      end
    end
  rescue Exception => e
    flash[:error] = "#{e}"
    redirect_to :back
  end
  
  # DELETE /bids/1
  # DELETE /bids/1.xml
  # deleting a bid removes it from the Bid Basket and refreshes the current page
  def destroy
    @bid = Bid.find_by_user_id_and_auction_id(@current_user.id, params[:id])
    if @bid.amount == 0
      @bid.destroy
      respond_to do |format|
        format.html { redirect_to :back }
        format.xml  { head :ok }
      end
    else
      flash[:error] = 'No one is allowed to delete an active bid.'
      redirect_to alerts_path
    end
  end
  
  private
  
  # set the failure flag and set an error message
  def failure(err_msg)
    @fail = true
    @err_msg = err_msg
  end
  
  # calculate what is owed us
  def money_for_us(auction)
    total_sale = auction.current_bid * auction.quantity
    if auction.premium_service
      total_sale * 0.1 # ten percent commission
    else
      total_sale * 0.05 # five percent commission
    end
  end
  
  def charge_the_seller(auction, bid)
    unless auction.test_only?
      right_now = Time.now
      unless auction.bill_me?
        begin
          #logger.info "\n\n#{Time.now}: attempting to charge credit card\n\n"
          organization = Organization.find(auction.user.organizations.first.id)
          if organization.card_info.nil?
            begin
              AuctionMailer::deliver_missing_card_alert(auction)
            rescue
              #logger.info "Could not email missing card alert at #{Time.now}.\n"
            end
            raise Exception, "No credit card number on file for #{organization.name}.\n"
          else
            credit_card = organization.card_info.creditcard('making money')
          end        
          gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
            :login  => '8zC26PftE',
            :password => '82e69aTF2hQyb6QZ')
          response = gateway.purchase((auction.due_foodmoves * 100), credit_card)
          if response.success?
            if auction.update_attributes(:date_billed => right_now,
                                          :date_paid => right_now)
              msg = "Successfully charged #{organization.name} for auction #{auction.id}."
              # logger.info "#{Time.now}: #{msg}\n"
            else
              msg =  "Charged #{organization.name} for auction #{auction.id} but unable to update database."
              # logger.info "#{Time.now}: #{msg}\n"
            end
          else
            msg = "Credit card error reported by Authorize.net: #{response.message}"
            # logger.info "#{Time.now}: #{msg}\n"
          end
        rescue Exception => e
          logger.info "#{Time.now}: #{e}\n"
        end
      else
        auction.update_attributes(:date_billed => right_now)
      end
      begin
        # logger.info "#{Time.now}: going to send invoice\n"
        AuctionMailer::deliver_invoice_to_seller(auction, bid)
      rescue
        # logger.info "Could not email invoice at #{Time.now}.\n"
      end
    end
  end
end
