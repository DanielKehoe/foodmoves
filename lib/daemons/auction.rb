#!/usr/bin/env ruby

#You might want to change this
ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../../config/environment"

$running = true;
Signal.trap("TERM") do 
  $running = false
  ActiveRecord::Base.logger.info "#{Time.now}: auction daemon halted\n"
  begin
    AuctionMailer::deliver_notify_admin_of_stop
  rescue
    ActiveRecord::Base.logger.info "Could not email admin at #{Time.now}.\n"
  end
  exit
end

# log to the file "production.log" when the daemon first starts
ActiveRecord::Base.logger.info "#{Time.now}: auction daemon started\n"
begin
  AuctionMailer::deliver_notify_admin_of_startup
rescue
  ActiveRecord::Base.logger.info "Could not email admin at #{Time.now}.\n"
end

while($running) do
  
  # For testing:
  # ActiveRecord::Base.logger.info "This daemon is still running at #{Time.now}.\n"

  # ***********************************
  # 	find any auction listings expiring now
  # ***********************************

  auctions = Auction.find(:all,
                          :conditions => ["date_to_end <= :now && closed = 0 && consignment = 0 ",
                            { :now => Time.now } ],
                          :order => "created_at ASC")  

  # ***********************************
  # 	evaluate and close each expiring auction listing
  # ***********************************
    
  auctions.each do |auction|
       
    # For testing:
    #ActiveRecord::Base.logger.info auction.id.to_s + ". closed \"" + auction.description + "\"\n"

    # ***********************************
    # 	check if there is a winner
    # ***********************************

    # did anyone bid?
    if auction.current_bid > 0
      # find the most recent bid
      bid = Bid.find_by_auction_id(auction.id, :order => "updated_at DESC")
      begin
        bid.update_attributes(:closed => true,
                              :winner => true,
                              :closed_at => Time.now)
      rescue
        ActiveRecord::Base.logger.info "Could not update bid at #{Time.now}.\n"
      end
      begin
        total_sale = auction.current_bid * auction.quantity
        if auction.premium_service
          commission = total_sale * 0.1 # ten percent commission
        else
          commission = total_sale * 0.05 # five percent commission
        end
        auction.update_attributes(:closed => true,
                              :buyer_id => bid.user_id,
                              :sale_total => total_sale,
                              :due_foodmoves => commission)
      rescue
        ActiveRecord::Base.logger.info "Could not update auction at #{Time.now}.\n"
      end     
      begin
        # send email to the seller "you found a buyer"
        AuctionMailer::deliver_notify_seller_of_sale(auction, bid)
      rescue
        ActiveRecord::Base.logger.info "Could not email seller at #{Time.now}.\n"
      end
      unless auction.test_only?
        right_now = Time.now
        unless auction.bill_me?
          begin
            # ActiveRecord::Base.logger.info "\n\n#{Time.now}: attempting to charge credit card\n\n"
            organization = Organization.find(auction.user.organizations.first.id)
            if organization.card_info.nil?
              begin
                AuctionMailer::deliver_missing_card_alert(auction)
              rescue
                ActiveRecord::Base.logger.info "Could not email missing card alert at #{Time.now}.\n"
              end
              ActiveRecord::Base.logger.info "No credit card number on file for #{organization.name}.\n"
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
                # ActiveRecord::Base.logger.info "#{Time.now}: #{msg}\n"
              else
                msg =  "Charged #{organization.name} for auction #{auction.id} but unable to update database."
                # ActiveRecord::Base.logger.info "#{Time.now}: #{msg}\n"
              end
            else
              msg = "Credit card error reported by Authorize.net: #{response.message}"
              ActiveRecord::Base.logger.info "#{Time.now}: #{msg}\n"
            end
          rescue Exception => e
            ActiveRecord::Base.logger.info "#{Time.now}: #{e}\n"
          end
        else
          auction.update_attributes(:date_billed => right_now)
        end
        begin
          ActiveRecord::Base.logger.info "#{Time.now}: going to send invoice\n"
          AuctionMailer::deliver_invoice_to_seller(auction, bid)
        rescue
          ActiveRecord::Base.logger.info "Could not email invoice at #{Time.now}.\n"
        end
      end
      begin
        # send email to the top bidder "you are the winner"
        AuctionMailer::deliver_notify_buyer_of_sale(auction, bid)
      rescue
        ActiveRecord::Base.logger.info "Could not email buyer at #{Time.now}.\n"
      end
    else
      begin
        # send email to the seller "no offers"
        AuctionMailer::deliver_notify_seller_of_no_sale(auction)
      rescue
        ActiveRecord::Base.logger.info "Could not email no-sale notice at #{Time.now}.\n"
      end
    end	  		   
  end

  # ***********************************
  # 	mark the listings "closed" 
  #   and update the database
  # ***********************************
  begin
    if auctions.size > 0
      # ActiveRecord::Base.logger.info "Closing #{auctions.size} auctions at #{Time.now}.\n"
      result = Auction.update_all("closed = 1", ["date_to_end <= :now && closed = 0",
        { :now => Time.now } ]) 
    end
  rescue
    ActiveRecord::Base.logger.info "Could not close #{auctions.size} auctions at #{Time.now}.\n"
  end
  
  # wait five minutes before running again
  # ActiveRecord::Base.logger.info "finished loop at #{Time.now}.\n"
  sleep 300
end
