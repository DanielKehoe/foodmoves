class Admin::HomeController < ApplicationController

  layout "admin"
  
    # from acl_system2 example
    before_filter :login_required
    access_control :DEFAULT => '(admin | manager | support)',
                    :renumber_prospects => 'admin'

    # a utility for one-time use, prior to combining Prospect and Organization table
    def renumber_prospects
      n = 1
      beginning = n
      loop do
        logger.info "\nn = #{n}"
        Prospect.connection.execute("UPDATE prospects SET id = id + 4000 where id = #{n}", nil)
        Phone.connection.execute("UPDATE phones SET phonable_id = phonable_id + 4000 where phonable_id = #{n} and phonable_type = 'Prospect'", nil)
        Address.connection.execute("UPDATE addresses SET addressable_id = addressable_id + 4000 where addressable_id = #{n} and addressable_type = 'Prospect'", nil)
        Contact.connection.execute("UPDATE contacts SET organization_id = organization_id + 4000 where organization_id = #{n}", nil)
        n = n + 1
        break if n > 140
      end
      flash[:notice] = "completed renumbering of prospects #{beginning} to #{n}"
      redirect_to alerts_path
    rescue Exception => e
      flash[:error] = "FAILURE: #{e}"
      logger.info "\n\n FAILURE: #{e}\n\n"
      redirect_to alerts_path
    end

    def index
      @affiliations_pending_count = Affiliation.count_all_pending
      @auctions_completed = Auction.count_completed
      @auctions_completed_last_72hrs = Auction.count_completed_last_72hrs
      @auctions_completed_last_24hrs = Auction.count_completed_last_24hrs
      @auctions_count = Auction.count_current
      @bids_count = Bid.count_all_current
      @expiring_count = Auction.count_expiring
      @users_count = User.count_all
      @nixies_count = User.count_all_nixies
      @guests_count = User.count_all_guests
      @members_count = User.count_all_members
      @sellers_count = User.count_all_sellers
      @buyers_count = User.count_all_buyers
      @users_count_last_7_days = User.count_all_last_7_days
      @nixies_count_last_7_days = User.count_nixies_last_7_days
      @guests_count_last_7_days = User.count_guests_last_7_days
      @members_count_last_7_days = User.count_members_last_7_days
      @users_count_last_day = User.count_all_last_day
      @nixies_count_last_day = User.count_nixies_last_day
      @guests_count_last_day = User.count_guests_last_day
      @members_count_last_day = User.count_members_last_day
      @members_count_logins_last_72_hrs = User.count_all_members_logins_last_72_hrs
      @sellers_count_logins_last_72_hrs = User.count_all_sellers_logins_last_72_hrs
      @buyers_count_logins_last_72_hrs = User.count_all_buyers_logins_last_72_hrs
      @members_count_logins_last_day = User.count_all_members_logins_last_day
      @sellers_count_logins_last_day = User.count_all_sellers_logins_last_day
      @buyers_count_logins_last_day = User.count_all_buyers_logins_last_day
      @buyers_active_last_day = Bid.count_bidders_last_day
      @sellers_active_last_day = Auction.count_sellers_last_day
      @members_active_last_day = Bid.count_bidders_last_day + Auction.count_sellers_last_day
      @members_count_0days_ago = User.members_count_0days_ago
      @members_count_1days_ago = User.members_count_1days_ago
      @members_count_2days_ago = User.members_count_2days_ago
      @members_count_3days_ago = User.members_count_3days_ago
      @members_count_4days_ago = User.members_count_4days_ago
      @members_count_5days_ago = User.members_count_5days_ago
      @members_count_6days_ago = User.members_count_6days_ago
      @members_count_7days_ago = User.members_count_7days_ago
      @members_count_8days_ago = User.members_count_8days_ago
      @guests_count_0days_ago = User.guests_count_0days_ago
      @guests_count_1days_ago = User.guests_count_1days_ago
      @guests_count_2days_ago = User.guests_count_2days_ago
      @guests_count_3days_ago = User.guests_count_3days_ago
      @guests_count_4days_ago = User.guests_count_4days_ago
      @guests_count_5days_ago = User.guests_count_5days_ago
      @guests_count_6days_ago = User.guests_count_6days_ago
      @guests_count_7days_ago = User.guests_count_7days_ago
      @guests_count_8days_ago = User.guests_count_8days_ago
      @nixies_count_0days_ago = User.nixies_count_0days_ago
      @nixies_count_1days_ago = User.nixies_count_1days_ago
      @nixies_count_2days_ago = User.nixies_count_2days_ago
      @nixies_count_3days_ago = User.nixies_count_3days_ago
      @nixies_count_4days_ago = User.nixies_count_4days_ago
      @nixies_count_5days_ago = User.nixies_count_5days_ago
      @nixies_count_6days_ago = User.nixies_count_6days_ago
      @nixies_count_7days_ago = User.nixies_count_7days_ago
      @nixies_count_8days_ago = User.nixies_count_8days_ago
      @all_count_0days_ago = User.all_count_0days_ago
      @all_count_1days_ago = User.all_count_1days_ago
      @all_count_2days_ago = User.all_count_2days_ago
      @all_count_3days_ago = User.all_count_3days_ago
      @all_count_4days_ago = User.all_count_4days_ago
      @all_count_5days_ago = User.all_count_5days_ago
      @all_count_6days_ago = User.all_count_6days_ago
      @all_count_7days_ago = User.all_count_7days_ago
      @all_count_8days_ago = User.all_count_8days_ago
      @users = User.find(:all,
                  :limit => 5, 
                  :order => "last_login_at DESC")
    end

    # blocks some errors generated by scripts probing for security exploits
    def show
      flash[:notice] = "You were denied access to the site."
      logger.info "\n\nPossible attempt at security exploit.\n\n"
      raise AccessDenied
    end

    protected

    def permission_denied
      flash[:notice] = "You were denied access to the administrative home page."
      raise AccessDenied
    end

  end