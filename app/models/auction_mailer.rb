class AuctionMailer < ActionMailer::ARMailer
    @@bcc = ['archive@foodmoves.com']
    @@from = 'Foodmoves Support <support@foodmoves.com>'

    def test_mail(current_user)
      @subject = "Test Message"
  		@recipients = current_user.email
  		@from       = @@from
      @sent_on    = Time.now
      @headers    = {}
    end

    def notify_admin_of_startup
      @subject = "Auction Daemon Started"
  		@recipients = 'Foodmoves <admin@foodmoves.com>'
  		@from       = @@from
      @sent_on    = Time.now
      @headers    = {}
    end

    def notify_admin_of_stop
      @subject = "Auction Daemon Stopped"
  		@recipients = 'Foodmoves <admin@foodmoves.com>'
  		@from       = @@from
      @sent_on    = Time.now
      @headers    = {}
    end

    def notify_seller_of_new_listing(auction)
      @subject = "Auction Listing Confirmed: #{auction.description}"
      @body       = {:auction => auction}
      @recipients = auction.user.email
  		@bcc        = @@bcc
  		@from       = @@from
      @sent_on    = Time.now
      @headers    = {}
    end

    def buyer_alert(user, auction)
      @subject = "#{auction.description}"
      @body       = {:auction => auction, :user => user}
  		@recipients = user.email
  		@bcc        = @@bcc
  		@from       = @@from
      @sent_on    = Time.now
      @headers    = {}
    end
    
    def nixie_buyer_alert(user, auction)
      @subject = "#{auction.description}"
      @body       = {:auction => auction, :user => user}
  		@recipients = user.email
  		@bcc        = @@bcc
  		@from       = @@from
      @sent_on    = Time.now
      @headers    = {}
    end
    
    def notify_bid_was_accepted(auction, bid)
      @subject = "You Are the Top Bidder for #{auction.description}"
      @body       = {:auction => auction, :bid => bid}
      @recipients = bid.user.email
  		@bcc        = @@bcc
  		@from       = @@from
      @sent_on    = Time.now
      @headers    = {}
    end
            
    def notify_bidder_was_outbid(auction, old_bid)
      @subject = "You've Been Outbid for #{auction.description}"
      @body       = {:auction => auction, :old_bid => old_bid}
      @recipients = old_bid.user.email
  		@bcc        = @@bcc
  		@from       = @@from
      @sent_on    = Time.now
      @headers    = {}
    end
              
    def notify_seller_of_sale(auction, bid)
      @subject = "Sold at Auction: #{auction.description}"
      @body       = {:auction => auction, :bid => bid}
      @recipients = auction.user.email
  		@bcc        = @@bcc
  		@from       = @@from
      @sent_on    = Time.now
      @headers    = {}
    end

    def invoice_to_seller(auction, bid)
      @subject = "Invoice from Foodmoves for Auction #{auction.id}"
      @body       = {:auction => auction, :bid => bid}
      @recipients = auction.user.email
  		@bcc        = @@bcc
  		@from       = @@from
      @sent_on    = Time.now
      @headers    = {}
    end
    
    def notify_buyer_of_sale(auction, bid)
      @subject = "You've Won an Auction for #{auction.description}"
      @body       = {:auction => auction, :bid => bid}
  		@recipients = bid.user.email
  		@bcc        = @@bcc
  		@from       = @@from
      @sent_on    = Time.now
      @headers    = {}
    end

    def notify_seller_of_no_sale(auction)
      @subject = "Not Sold, No Offers: #{auction.description}"
      @body       = {:auction => auction}
  		@recipients = auction.user.email
  		@bcc        = @@bcc
  		@from       = @@from
      @sent_on    = Time.now
      @headers    = {}
    end

    def notify_seller_of_buynow_sale(auction, bid)
      @subject = "Sold (It's Yours!): #{auction.description}"
      @body       = {:auction => auction, :bid => bid}
      @recipients = auction.user.email
  		@bcc        = @@bcc
  		@from       = @@from
      @sent_on    = Time.now
      @headers    = {}
    end

    def notify_buyer_of_buynow_sale(auction, bid)
      @subject = "It's Yours!: #{auction.description}"
      @body       = {:auction => auction, :bid => bid}
  		@recipients = bid.user.email
  		@bcc        = @@bcc
  		@from       = @@from
      @sent_on    = Time.now
      @headers    = {}
    end
    
    def missing_card_alert(auction)
      @subject = "Missing Credit Card"
      @body       = {:auction => auction}
  		@recipients = auction.user.email
  		@bcc        = @@bcc
  		@from       = @@from
      @sent_on    = Time.now
      @headers    = {}
    end        
  end

