class Admin::SendController < ApplicationController

  layout "admin"

  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager | support)'

  def index
    respond_to do |format|
      format.html # index.rhtml
    end
  end

  def test_mail
    begin
      AuctionMailer::deliver_test_mail(@current_user)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for test_mail."
    end
    redirect_to alerts_path
  end

  def signup
    begin
      InvitationMailer::deliver_signup(@current_user)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for confirm."
    end
    redirect_to alerts_path
  end

  def new_buyer_invite
    begin
      watched_item = WatchedProduct.find(:first)
    rescue
      failure "Unable to find first watched item."
    end
    begin
      InvitationMailer::deliver_new_buyer_invite(@current_user, watched_item, @current_user)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for new_buyer_invite."
    end
    redirect_to alerts_path
  end
  
  def invite
    begin
      InvitationMailer::deliver_invite(@current_user, 'a test', @current_user)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for invite."
    end
    redirect_to alerts_path
  end
  
  def affiliation
    begin
      company = Organization.find(:first)
    rescue
      failure "Unable to find a company."
    end
    begin
      InvitationMailer::deliver_affiliation(@current_user, company)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for affiliation."
    end
    redirect_to alerts_path
  end
  
  def approval
    begin
      company = Organization.find(:first)
    rescue
      failure "Unable to find a company."
    end
    begin
      InvitationMailer::deliver_approval(@current_user, company)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for approval."
    end
    redirect_to alerts_path
  end

  def denial
    begin
      company = Organization.find(:first)
    rescue
      failure "Unable to find a company."
    end
    affiliation = Affiliation.new
    affiliation.reviewed_at = Time.now
    affiliation.talked_to = 'Elmo Bogus'
    affiliation.notes = 'A lot of nonsense'
    affiliation.called_by = 'Grover Fakus'
    begin
      InvitationMailer::deliver_denial(@current_user, company, affiliation)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for denial."
    end
    redirect_to alerts_path
  end  
  
  def notify_seller_of_new_listing
    begin
      auction = Auction.find(:first)
    rescue
      failure "Unable to find an Auction."
    end
    auction.seller_id = @current_user.id
    begin
      AuctionMailer::deliver_notify_seller_of_new_listing(auction)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for notify_seller_of_new_listing."
    end
    redirect_to alerts_path
  end

  def notify_bid_was_accepted
    begin
      auction = Auction.find(:first)
    rescue
      failure "Unable to find an Auction."
    end
    begin
      bid = Bid.find(:first)
    rescue
      failure "Unable to find a Bid."
    end
    auction.seller_id = @current_user.id
    bid.user_id = @current_user.id
    begin
      AuctionMailer::deliver_notify_bid_was_accepted(auction, bid)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for notify_bid_was_accepted."
    end
    redirect_to alerts_path
  end
          
  def notify_bidder_was_outbid
    begin
      auction = Auction.find(:first)
    rescue
      failure "Unable to find an Auction."
    end
    begin
      bid = Bid.find(:first)
    rescue
      failure "Unable to find a Bid."
    end
    auction.seller_id = @current_user.id
    bid.user_id = @current_user.id
    begin
      AuctionMailer::deliver_notify_bidder_was_outbid(auction, bid)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for notify_bidder_was_outbid."
    end
    redirect_to alerts_path
  end
            
  def notify_seller_of_sale
    begin
      auction = Auction.find(:first)
    rescue
      failure "Unable to find an Auction."
    end
    begin
      bid = Bid.find(:first)
    rescue
      failure "Unable to find a Bid."
    end
    auction.seller_id = @current_user.id
    bid.user_id = @current_user.id
    begin
      AuctionMailer::deliver_notify_seller_of_sale(auction, bid)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for notify_seller_of_sale."
    end
    redirect_to alerts_path
  end

  def notify_buyer_of_sale
    begin
      auction = Auction.find(:first)
    rescue
      failure "Unable to find an Auction."
    end
    begin
      bid = Bid.find(:first)
    rescue
      failure "Unable to find a Bid."
    end
    auction.seller_id = @current_user.id
    bid.user_id = @current_user.id
    begin
      AuctionMailer::deliver_notify_buyer_of_sale(auction, bid)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for notify_buyer_of_sale."
    end
    redirect_to alerts_path
  end

  def notify_seller_of_no_sale
    begin
      auction = Auction.find(:first)
    rescue
      failure "Unable to find an Auction."
    end
    auction.seller_id = @current_user.id
    begin
      AuctionMailer::deliver_notify_seller_of_no_sale(auction)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for notify_seller_of_no_sale."
    end
    redirect_to alerts_path
  end
  
  def notify_buyer_of_buynow_sale
    begin
      auction = Auction.find(:first)
    rescue
      failure "Unable to find an Auction."
    end
    begin
      bid = Bid.find(:first)
    rescue
      failure "Unable to find a Bid."
    end
    auction.seller_id = @current_user.id
    bid.user_id = @current_user.id
    begin
      AuctionMailer::deliver_notify_buyer_of_buynow_sale(auction, bid)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for notify_buyer_of_buynow_sale."
    end
    redirect_to alerts_path
  end
    
  def notify_seller_of_buynow_sale
    begin
      auction = Auction.find(:first)
    rescue
      failure "Unable to find an Auction."
    end
    begin
      bid = Bid.find(:first)
    rescue
      failure "Unable to find a Bid."
    end
    auction.seller_id = @current_user.id
    bid.user_id = @current_user.id
    begin
      AuctionMailer::deliver_notify_seller_of_buynow_sale(auction, bid)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for notify_seller_of_buynow_sale."
    end
    redirect_to alerts_path
  end

  def buyer_alert
    begin
      auction = Auction.find(:first)
    rescue
      failure "Unable to find an Auction."
    end
    begin
      AuctionMailer::deliver_buyer_alert(@current_user, auction)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for buyer_alert."
    end
    redirect_to alerts_path
  end
  
  def nixie_buyer_alert
    begin
      auction = Auction.find(:first)
    rescue
      failure "Unable to find an Auction."
    end
    begin
      AuctionMailer::deliver_nixie_buyer_alert(@current_user, auction)
    rescue
      failure "Unable to send email."
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
    else
      flash[:notice] = "Sent email. Check your mailbox for buyer_alert."
    end
    redirect_to alerts_path
  end
  
  protected

  def permission_denied
    flash[:notice] = "You were denied access to the email test page."
    raise AccessDenied
  end

  private
  
  # set the failure flag and set an error message
  def failure(err_msg)
    @fail = true
    @err_msg = err_msg
  end
  
end