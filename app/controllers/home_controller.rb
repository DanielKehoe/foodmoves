class HomeController < ApplicationController
  
  def index
    # CHECK IF NO ADMINISTRATOR HAS BEEN SET UP
    begin
      user = User.find(:first) or raise ActiveRecord::RecordNotFound
    rescue
      # redirect to a page to create a new administrator if no users are found
      logger.info "\n\nNO USERS WERE FOUND, TIME TO CREATE A FIRST USER?\n\n"
      redirect_to new_administrator_url
    end
    # SET NEW GUEST FOR LOGIN FORM
    @guest = Guest.new
    # GET NEWEST AUCTIONS
    @auctions = Auction.find :all,
                  :conditions => ["test_only = 0 and consignment = 0 and date_to_end >= :now",
                      { :now => Time.now } ],
                  # :limit => 10,
                  :order => 'date_to_end ASC'
    # GET FEATURED AUCTION
    @featured = Auction.find :first,
                  :conditions => ["test_only = 0 and consignment = 0 and date_to_end >= :now",
                      { :now => Time.now } ],
                  :order => 'date_to_end ASC'                
    #RENDER
    render(:layout => false)
  end

  private 
       
  # borrowed from vendor/rails/actionpack/lib/action_view/helpers/number_helper.rb, line 55
  def number_to_currency(number, options = {})
    options   = options.stringify_keys
    precision = options["precision"] || 2
    unit      = options["unit"] || "$"
    separator = precision > 0 ? options["separator"] || "." : ""
    delimiter = options["delimiter"] || ","
    begin
      parts = number_with_precision(number, precision).split('.')
      unit + number_with_delimiter(parts[0], delimiter) + separator + parts[1].to_s
    rescue
      number
    end
  end

  # borrowed from vendor/rails/actionpack/lib/action_view/helpers/number_helper.rb, line 104
  def number_with_delimiter(number, delimiter=",", separator=".")
    begin
      parts = number.to_s.split('.')
      parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
      parts.join separator
    rescue
      number
    end
  end

  # borrowed from vendor/rails/actionpack/lib/action_view/helpers/number_helper.rb, line 119
  def number_with_precision(number, precision=3)
    "%01.#{precision}f" % number
  rescue
    number
  end
  
end
