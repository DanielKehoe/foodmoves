class ConsignmentsController < ApplicationController

  layout "admin"

  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager | support)'

  # Standard RESTful methods

  # GET /consignments
  # GET /consignments.xml
  def index
    @auctions = Auction.find_consignments
    respond_to do |format|
      format.html # index.rhtml
    end
  end

  # GET /consignments/1;edit
  def edit
    @auction = Auction.find(params[:id])
    @auction.current_bid = @auction.minimum_bid
    unless @auction.buyer_id.nil?
      @buyer = User.find(@auction.buyer_id)
    end
  end

  # PUT /consignments/1
  # PUT /consignments/1.xml
  def update
    if params[:auction].nil?
      failure "Error in closing consignment sale."
    end
    if params[:auction][:current_bid].blank?
      failure "You did not enter a closing price."
    end
    if params[:auction][:quantity].blank?
      failure "You did not enter a closing quantity."
    end
    unless @fail
      @auction = Auction.find(params[:id])
      unless params[:auction][:current_bid].nil?
        current_bid = params[:auction][:current_bid]
        current_bid.tr!('$,','')
        @auction.current_bid = current_bid
      end
      @auction.reserve_price = @auction.minimum_bid = @auction.current_bid
      @auction.buy_now_price = @auction.current_bid
      @auction.quantity = @auction.min_quantity = params[:auction][:quantity]
      unless @auction.cases_per_pallet.nil? or @auction.quantity.nil?
        @auction.pallets = (@auction.quantity.to_f / @auction.cases_per_pallet.to_f).ceil
      end
      @auction.how_many_bids = 1
      @auction.last_bid_id = @auction.buyer_id
      @auction.date_to_pickup = @auction.date_last_bid = @auction.date_to_end = Time.now
      @auction.consignment = false
      @auction.closed = true
      @auction.due_foodmoves = money_for_us(@auction)
      if @auction.save
        flash[:notice] = "Successfully closed auction #{@auction.id}."
        chat_alert('team', "#{@current_user.name} " +
              "has closed a consignment sale for #{@auction.description}")
      else
        flash[:notice] = "Unable to close auction #{@auction.id}."
      end
    end
    if @fail
      flash[:error] = @err_msg
    end
    redirect_to consignments_url
  end
  
  private
  
  # set the failure flag and set an error message
  def failure(err_msg)
    @fail = true
    @err_msg = err_msg
    logger.info "\n\n#{@err_msg}\n\n"
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
end
