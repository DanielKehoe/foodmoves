class AuctionsController < ApplicationController
  
  layout "admin"

  # from acl_system2 example
  before_filter :login_required, :except => 'show'
  access_control [:new, :create, :edit, :update] => 'member',
                  [:index] => '(admin | manager | support)'
  
  # as suggested by Stuart Rackham's Rails Date Kit for a calendar date select widget
  helper :date

  def step_two_for_new
    flash[:error] = nil
    @auction = Auction.new(params[:auction])
    if @auction.address.nil?
      flash[:error] = "You did not specify a \"Shipping From\" location."
    end
    if @auction.date_to_start.nil?
      flash[:error] = "You did not specify a date and time for the auction to start."
    end
    if @auction.date_to_end.nil?
      flash[:error] = "You did not specify a date and time for the auction to end."
    end
    unless params[:auction][:food_id].nil?
      @food = Food.find(@auction.food_id)
    else
      unless params[:auction][:food_parent_id].nil?
        @food = Food.find(params[:auction][:food_parent_id])
        @auction.food_id = params[:auction][:food_parent_id]
      else
        @food = Food.find(params[:auction][:food_grandparent_id])
        @auction.food_id = params[:auction][:food_grandparent_id]
      end
    end
    if @food.name.include?(@food.parent.name)
      @auction.description = @food.name
    else
      @auction.description = "#{@food.name} (#{@food.parent.name})"
    end
    @auction.plu = @food.plu
    unless @auction.plu == 0
      @auction.plu_stickered = true
    else
      @auction.plu_stickered = false
    end
    if @current_user.country == 'US'
      @auction.celsius = false
    else
      @auction.celsius = true
    end
    @auction.barcoded = false
    @auction.organic = false
    @auction.fair_trade = false
    @auction.kosher = false
    @qualities = Quality.find(:all, :order => 'sort_order, name')
    @conditions = Condition.find(:all, :order => 'sort_order, name')
    # GROWNS
    @growns = @food.growns
    if @growns.size == 0
      @growns = @food.parent.growns
    end
    if @growns.size == 0
      @growns = @food.parent.parent.growns
    end
    if @growns.size == 0
      @growns = @food.parent.parent.parent.growns
    end 
    # PACKS
    @packs = @food.packs
    if @packs.size == 0
      @packs = @food.parent.packs
    end
    if @packs.size == 0
      @packs = @food.parent.parent.packs
    end
    if @packs.size == 0
      @packs = @food.parent.parent.parent.packs
    end
    # PER_CASES
    @per_cases = @food.per_cases
    if @per_cases.size == 0
      @per_cases = @food.parent.per_cases
    end
    if @per_cases.size == 0
      @per_cases = @food.parent.parent.per_cases
    end 
    if @per_cases.size == 0
      @per_cases = @food.parent.parent.parent.per_cases
    end
    # SIZES   
    @sizes = @food.sizes
    if @sizes.size == 0
      @sizes = @food.parent.sizes
    end
    if @sizes.size == 0
      @sizes = @food.parent.parent.sizes
    end 
    if @sizes.size == 0
      @sizes = @food.parent.parent.parent.sizes
    end
    # WEIGHTS
    @weights = @food.weights
    if @weights.size == 0
      @weights = @food.parent.weights
    end
    if @weights.size == 0
      @weights = @food.parent.parent.weights
    end
    if @weights.size == 0
      @weights = @food.parent.parent.parent.weights
    end
    # COLORS
    @colors = @food.colors
    if @colors.size == 0
      @colors = @food.parent.colors
    end
    if @colors.size == 0
      @colors = @food.parent.parent.colors
    end
    if @colors.size == 0
      @colors = @food.parent.parent.parent.colors
    end
    # RENDER
    render :partial => 'form', :layout => false
  end

  def confirm
    @auction = Auction.new(params[:auction])
    @auction.seller_id = @current_user.id
    @allow = true
    if @auction.date_to_start.nil?
      failure "You did not specify an \"auction start date and time\"." 
    else
      if @auction.date_to_start < TzTime.zone.utc_to_local(Time.now - 30.minutes)
        # failure "Your \"auction start date and time\" cannot be earlier than 30 minutes ago." 
      end
    end
    if @auction.date_to_end.nil?
      failure "You did not specify an \"auction end date and time\"."
    else
      if @auction.date_to_end < TzTime.zone.utc_to_local(Time.now + 30.minutes)
        # failure "Your \"auction end date and time\" cannot be sooner than 30 minutes from now." 
      else
        @auction.date_to_pickup = @auction.date_to_end + (60 * 60 * @auction.pickup_limit) # 24 or 48 r 72 hrs after date_to_end  
      end
    end
    unless @auction.cases_per_pallet.nil? or @auction.quantity.nil?
      @auction.pallets = (@auction.quantity.to_f / @auction.cases_per_pallet.to_f).ceil
    end 
    # MINIMUM BID
    if params[:auction][:minimum_bid].blank?
      failure "You did not specify a \"minimum bid\"."
      @allow = false
    else
      minimum_bid = params[:auction][:minimum_bid]
      minimum_bid.tr!('$,','')
      @auction.minimum_bid = minimum_bid.to_f
      if @auction.minimum_bid == 0
        failure "You did not specify a \"minimum bid\"."
        @allow = false
      end
    end
    # IT'S YOURS PRICE
    unless params[:auction][:buy_now_price].blank?
      buy_now_price = params[:auction][:buy_now_price]
      buy_now_price.tr!('$,','')
      @auction.buy_now_price = buy_now_price
    end
    # RESERVE PRICE
    # eliminate Reserve Price (just set it equal to Minimum Bid)
    @auction.reserve_price = @auction.minimum_bid
    # QUANTITY
    if @auction.quantity.blank?
      failure "You did not specify a \"quantity\"."
      @allow = false
    else
      if @auction.quantity == 0
        failure "You did not specify a \"quantity\"."
        @allow = false
      end
    end
    # CASES PER PALLET
    if @auction.cases_per_pallet.blank?
      failure "You did not specify \"cases per pallet\"."
      @allow = false
    else
        if @auction.cases_per_pallet == 0
          failure "You did not specify \"cases per pallet\"."
          @allow = false
        end
    end
    # QUALITIES
    if @auction.quality.nil?
      failure "You did not specify a \"quality\"."
      @allow = false
    end
    # CONDITIONS
    if @auction.condition.nil?
      failure "You did not specify a \"condition\"."
      @allow = false
    end
    # GROWNS
    if @auction.grown.nil?
      failure "You did not specify \"how grown\"."
      @allow = false
    end
    # PACKS
    if @auction.pack.nil?
      failure "You did not specify \"how packed\"."
      @allow = false
    end
    # PER_CASES
    if @auction.per_case.nil?
      failure "You did not specify a \"case count\"."
      @allow = false
    end
    # SIZES   
    if @auction.size.nil?
      failure "You did not specify a \"size\"."
      @allow = false
    end
    # WEIGHTS
    if @auction.weight.nil?
      failure "You did not specify a \"weight\"."
      @allow = false
    end
    if @fail
      @procedure = 'ok_for_new'
      populate_for_edit
      flash[:error] = @err_msg
      render :action => 'edit', :layout => 'forms_wide'
    else
      @procedure = 'ok_for_new'
      populate_for_edit
      render :action => 'edit', :layout => 'forms_wide'
    end
  end
           
  # GET /auctions
  # GET /auctions.xml
  def index
    @failures = Auction.paginate :per_page => 25, 
                                  :page => params[:page],
                                  :conditions => ["closed = 0 and date_to_end < :now",
                                            { :now => Time.now } ],
                                  :order => 'created_at DESC'
    @auctions = Auction.paginate :per_page => 25, 
                                  :page => params[:page],
                                  :conditions => ['closed = 0 and description like ?', "%#{params[:search]}%"], 
                                  :order => 'created_at DESC'
    @expired = Auction.paginate :per_page => 25, 
                                  :page => params[:page],
                                  :conditions => ['closed = 1 and description like ?', "%#{params[:search]}%"],
                                  :order => 'created_at DESC'
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @auctions.to_xml }
      format.csv {
        all = Auction.find :all, :order => 'created_at DESC'
        render :text => all.to_csv 
        response.headers['Content-Type'] = 'text/csv; charset=utf-8; header=present'
        response.headers['Content-Disposition'] = "attachment; filename=auctions_#{Time.now.strftime("%d-%m-%Y-%H-%M-%S")}.csv"
      }
    end
  end
    
  # GET /auctions/1
  # GET /auctions/1.xml
  def show
    @auction = Auction.find(params[:id])
    if @auction.lat? && @auction.lng?
      # use the YM4R/GM plugin to generate a map
      @map = GMap.new("mini_map")
      @map.control_init(:small_map => true)
      @map.center_zoom_init([@auction.lat,@auction.lng],5)
      @map.overlay_init(GMarker.new([@auction.lat,@auction.lng]))
    end
    unless @auction.buyer_id.nil?
      @buyer = User.find(@auction.buyer_id)
    end
    @auctions = Auction.current_auctions_alpha
    respond_to do |format|
      format.html { render :layout => 'forms_wide' } # show.rhtml
      format.xml  { render :xml => @auction.to_xml }
    end
  end

  # GET /auctions/new
  def new
    if @current_user.addresses.first.nil?
      flash[:error] = "You need to set an address for use as a \"Shipping From\" location."
      redirect_to new_user_address_path(@current_user)
    else
      unless @current_user.affiliations.first.approved_to_sell
        failure "When you were set up for trading, your company did not authorize you to sell."
      end
      if @current_user.organizations.first.creditworth.nil?
        failure "Your company's credit profile is not complete. Please contact our support team."
      end
      @auction = Auction.new
      @auction.date_to_start = TzTime.now
      @auction.date_to_end = TzTime.now + 5.days
      @auction.test_only = false
      @auction.bid_increment = 0.25 # set default
      @auction.allow_partial = false # set default
      @auction.for_export = true # set default
      @auction.organic = false # set default
      @auction.fair_trade = false # set default
      @auction.kosher = false # set default
      @auction.pickup_limit = '48' # set default
      @auction.feedback_id = 2 # set default
      @auction.creditworth_id = 4 # set default
      @auction.integrity_id = 2 # set default
      @auction.timeliness_id = 4 # set default
      populate_for_new
      if @fail
        flash[:error] = @err_msg
        redirect_to :back
      else
        flash[:error] = nil
        render :layout => 'forms_wide'
      end
    end
  end

  # GET /auctions/1/edit
  def edit
    @edit = true
    @auction = Auction.find(params[:id])
    if @auction
      if @auction.date_last_bid.nil?
        @procedure = 'ok_to_edit'
        @auction.date_to_start = TzTime.now
      else
        failure "Someone already bid. Auctions can not be edited or changed after a bid is received."
      end
    end
    populate_for_edit
    if @auction.lat? && @auction.lng?
      # use the YM4R/GM plugin to generate a map
      @map = GMap.new("mini_map")
      @map.control_init(:small_map => true)
      @map.center_zoom_init([@auction.lat,@auction.lng],5)
      @map.overlay_init(GMarker.new([@auction.lat,@auction.lng]))
    end
    if @fail
      flash[:error] = @err_msg
      redirect_to :back
    else
      render :layout => 'forms_wide'
    end
  end
  
  # used to make a duplicate of an existing auction
  # GET /auctions/1/quickcopy
  def quickcopy
    @edit = false
    template = Auction.find(params[:id])
    if template
      @procedure = 'ok_to_quickcopy'
    else
      failure "Unable to find an auction to copy."
    end
    @auction = Auction.new do |auction|
      auction.test_only = false
      # auction.id = template.id
      # auction.created_at = template.created_at        
      # auction.updated_at = template.updated_at        
      auction.date_to_start = TzTime.now
      auction.date_to_end = auction.date_to_start + (template.date_to_end - template.date_to_start)
      auction.seller_id = template.seller_id         
      auction.address_id = template.address_id        
      auction.lat = template.lat               
      auction.lng = template.lng               
      auction.reserve_price = template.reserve_price     
      auction.minimum_bid = template.minimum_bid       
      auction.bid_increment = template.bid_increment     
      # auction.how_many_bids = template.how_many_bids     
      # auction.date_last_bid = template.date_last_bid     
      # auction.current_bid = template.current_bid       
      # auction.closed = template.closed            
      # auction.buyer_id = template.buyer_id          
      auction.color_id = template.color_id
      auction.condition_id = template.condition_id      
      auction.food_id = template.food_id           
      auction.grown_id = template.grown_id          
      auction.pack_id = template.pack_id           
      auction.per_case_id = template.per_case_id       
      auction.quality_id = template.quality_id        
      auction.size_id = template.size_id           
      auction.weight_id = template.weight_id         
      auction.shipping_from = template.shipping_from     
      auction.description = template.description       
      auction.for_export = template.for_export        
      auction.origin_region_id = template.origin_region_id  
      auction.origin_country_id = template.origin_country_id 
      auction.plu = template.plu               
      auction.quantity = template.quantity          
      auction.allow_partial = template.allow_partial     
      auction.min_quantity = template.min_quantity      
      auction.feedback_id = template.feedback_id       
      auction.creditworth_id = template.creditworth_id    
      auction.timeliness_id = template.timeliness_id     
      auction.integrity_id = template.integrity_id      
      auction.plu_stickered = template.plu_stickered     
      auction.temperature = template.temperature       
      # auction.date_to_pickup = template.date_to_pickup    
      auction.celsius = template.celsius           
      auction.barcoded = template.barcoded          
      auction.lot_number = template.lot_number        
      auction.pickup_limit = template.pickup_limit      
      auction.cases_per_pallet = template.cases_per_pallet  
      auction.pallets = template.pallets           
      auction.test_only = template.test_only         
      auction.organic = template.organic           
      auction.fair_trade = template.fair_trade        
      auction.pickup_number = template.pickup_number     
      auction.kosher = template.kosher            
      auction.buy_now_price = template.buy_now_price     
      # auction.last_bid_id = template.last_bid_id          
      auction.iced = template.iced
      auction.certifications = template.certifications
      auction.treatments = template.treatments                 
    end
    @procedure = 'ok_for_new'
    populate_for_edit
    if @auction.lat? && @auction.lng?
      # use the YM4R/GM plugin to generate a map
      @map = GMap.new("mini_map")
      @map.control_init(:small_map => true)
      @map.center_zoom_init([@auction.lat,@auction.lng],5)
      @map.overlay_init(GMarker.new([@auction.lat,@auction.lng]))
    end
    if @fail
      flash[:error] = @err_msg
      render :action => "edit", :layout => 'forms_wide'
    else
      render :action => "edit", :layout => 'forms_wide'
    end
  end

  # POST /auctions
  # POST /auctions.xml
  def create
    @auction = Auction.new(params[:auction])
    if @auction.minimum_bid.blank?
      failure "You did not specify a \"Minimum Bid\"."
    end
    if params[:auction][:buy_now_price].blank?
      failure "You did not specify an \"It's Yours\" price."
    end
    if params[:auction][:bid_increment].blank?
      failure "You did not specify a \"bid increment\"."
    end
    if @auction.quantity.blank?
      failure "You did not specify a \"Quantity\"."
    end
    if @auction.cases_per_pallet.blank?
      failure "You did not specify \"Cases per Pallet\"."
    end
    if @auction.date_to_start.nil?
      failure "You did not specify an \"auction start date and time\"." 
    else
      if @auction.date_to_start < TzTime.zone.utc_to_local(Time.now - 30.minutes)
        unless @current_user.admin?
          failure "Your \"auction start date and time\" cannot be earlier than 30 minutes ago." 
        end
      end
    end
    if @auction.date_to_end.nil?
      failure "You did not specify an \"auction end date and time\"."
    else
      if @auction.date_to_end < TzTime.zone.utc_to_local(Time.now + 30.minutes)
        unless @current_user.admin?
          failure "Your \"auction end date and time\" cannot be sooner than 30 minutes from now."
        end
      end
      @auction.date_to_pickup = @auction.date_to_end + (60 * 60 * @auction.pickup_limit) # 24 or 48 r 72 hrs after date_to_end  
    end
    if @auction.seller_id.nil?
      @auction.seller_id = @current_user.id
    end
    unless @auction.buyer_id.nil?
      buyer = User.find(@auction.buyer_id)
      if buyer.organizations.first.nil?
        failure "The buyer is not affiliated with any organization."
      end
    end
    unless @auction.address_id.nil?
      @auction.shipping_from = @auction.address.location
    else 
      failure "You must have an address to use for \"shipping from\"."
    end
    unless @auction.cases_per_pallet.nil? or @auction.quantity.nil?
      @auction.pallets = (@auction.quantity.to_f / @auction.cases_per_pallet.to_f).ceil
    end
    # MINIMUM BID
    minimum_bid = params[:auction][:minimum_bid]
    minimum_bid.tr!('$,','')
    if minimum_bid.to_f == 0
      failure "The \"minimum bid\" cannot be zero."
    end
    @auction.minimum_bid = minimum_bid.to_f
    # IT'S YOURS PRICE
    buy_now_price = params[:auction][:buy_now_price]
    buy_now_price.tr!('$,','')
    if buy_now_price.to_f == 0
      failure "The \"It's Yours\" price cannot be zero."
    end
    @auction.buy_now_price = buy_now_price.to_f
    # BID INCREMENT
    bid_increment = params[:auction][:bid_increment]
    bid_increment.tr!('$,','')
    if bid_increment.to_f == 0
      failure "The \"bid increment\" cannot be zero."
    end
    @auction.bid_increment = bid_increment.to_f
    # RESERVE PRICE
    # eliminate Reserve Price (just set it equal to Minimum Bid)
    @auction.reserve_price = @auction.minimum_bid
    if @fail
      @procedure = 'ok_for_new'
      populate_for_edit
      flash[:error] = @err_msg
      render :action => 'edit', :layout => 'forms_wide'
    else
      if @auction.save
        flash[:notice] = 'Auction was successfully entered. You should add a photo now.'
        chat_alert('team', "#{@current_user.name} " +
              "has created a new auction for #{@auction.description}")
        chat_alert('user', "#{@current_user.name} has created a new auction for #{@auction.description}")
        unless @auction.test_only? 
          send_alerts(@auction)
        end
        redirect_to(:action => 'show', :id => @auction)
      else
        @procedure = 'ok_for_new'
        populate_for_edit
        flash[:error] = @err_msg
        render :action => 'edit', :layout => 'forms_wide'
      end
    end
  end

  # PUT /auctions/1
  # PUT /auctions/1.xml
  def update
    @original = Auction.find(params[:id])
    @auction = Auction.new(params[:auction])
    @auction.id = @original.id
    if @auction.quantity.blank?
      failure "You did not specify a \"Quantity\"."
    end
    if @auction.date_to_start.nil?
      failure "You did not specify an \"auction start date and time\"." 
    else
      if @auction.date_to_start < TzTime.zone.utc_to_local(Time.now - 30.minutes)
        # failure "Your \"auction start date and time\" cannot be earlier than 30 minutes ago." 
      end
    end
    if @auction.date_to_end.nil?
      failure "You did not specify an \"auction end date and time\"."
    else
      if @auction.date_to_end < TzTime.zone.utc_to_local(Time.now + 30.minutes)
        # failure "Your \"auction end date and time\" cannot be sooner than 30 minutes from now." 
         @auction.date_to_pickup = @auction.date_to_end + (60 * 60 * @auction.pickup_limit) # 24 or 48 r 72 hrs after date_to_end  
      else
        @auction.date_to_pickup = @auction.date_to_end + (60 * 60 * @auction.pickup_limit) # 24 or 48 r 72 hrs after date_to_end  
      end
    end 
    unless @auction.consignment 
      @auction.seller_id = @original.seller_id
      @auction.buyer_id = nil
    end
    unless @auction.buyer_id.nil?
      buyer = User.find(@auction.buyer_id)
      if buyer.organizations.first.nil?
        failure "The buyer is not affiliated with any organization."
      end
    end    
    unless @auction.address_id.nil?
      @auction.shipping_from = @auction.address.location
    else 
      failure "You must have an address to use for \"shipping from\"."
    end
    unless @auction.cases_per_pallet.nil? or @auction.quantity.nil?
      @auction.pallets = (@auction.quantity.to_f / @auction.cases_per_pallet.to_f).ceil
    end
    # MINIMUM BID
    if params[:auction][:minimum_bid].blank?
      failure "You did not specify a \"minimum bid\"."
    else
      minimum_bid = params[:auction][:minimum_bid]
      minimum_bid.tr!('$,','')
      @auction.minimum_bid = minimum_bid.to_f
      if @auction.minimum_bid == 0
        failure "You did not specify a \"minimum bid\"."
      end
    end
    # IT'S YOURS PRICE
    if params[:auction][:buy_now_price].blank?
      failure "You did not specify an \"It's Yours\" price."
    else
      buy_now_price = params[:auction][:buy_now_price]
      buy_now_price.tr!('$,','')
      @auction.buy_now_price = buy_now_price
    end
    # RESERVE PRICE
    # eliminate Reserve Price (just set it equal to Minimum Bid)
    @auction.reserve_price = @auction.minimum_bid
    # BID INCREMENT
    if params[:auction][:bid_increment].nil?
      failure "You did not specify a \"bid increment\"."
    else
      bid_increment = params[:auction][:bid_increment]
      bid_increment.tr!('$,','')
      @auction.bid_increment = bid_increment.to_f
      if @auction.bid_increment == 0
        failure "You did not specify a \"bid increment\"."
      end
    end
    if @fail
      flash[:error] = @err_msg
      @procedure = 'ok_to_edit'
      populate_for_edit
      render :action => "edit", :layout => 'forms_wide'
    else
      if @original.destroy
        if @auction.save!
          flash[:notice] = 'Auction was successfully updated.'
          chat_alert('team', "#{@current_user.name} " +
                "has modified an auction for #{@auction.description}")
          chat_alert('user', "#{@current_user.name} has modified an auction for #{@auction.description}") 
          redirect_to(:action => 'show', :id => @auction)
        else
          flash[:notice] = 'Unable to update auction.'
          @procedure = 'ok_to_edit'
          populate_for_edit
          render :action => "edit", :layout => 'forms_wide'
        end
      else
        flash[:notice] = 'Unable to update auction because the previous version could not be destroyed.'
        @procedure = 'ok_to_edit'
        populate_for_edit
        render :action => "edit", :layout => 'forms_wide'
      end    
    end
  end

  # DELETE /auctions/1
  # DELETE /auctions/1.xml
  def destroy
    @auction = Auction.find(params[:id])
    @auction.destroy
    respond_to do |format|
      format.html { redirect_to sell_url }
      format.xml  { head :ok }
    end
  end
  
  private 
  
  def populate_for_new
    @food = Food.find(:first)
    @food_root_children = Food.root.children
    @foods = Food.find(:all, :conditions => 'parent_id IS NOT NULL', :order => 'sort_order, name')
    @certifications = Certification.find(:all, :order => 'sort_order, name')
    @treatments = Treatment.find(:all, :order => 'sort_order, name')
    @feedback = Feedback.find(:all, :order => 'sort_order')
    @creditworth = Creditworth.find(:all, :order => 'sort_order')
    @integrity = Integrity.find(:all, :order => 'sort_order')
    @timeliness = Timeliness.find(:all, :order => 'sort_order')
    @tabbed = true
    @calendar = true
  end
  
  def populate_for_edit
    @certifications = Certification.find(:all, :order => 'sort_order, name')
    @treatments = Treatment.find(:all, :order => 'sort_order, name')
    @feedback = Feedback.find(:all, :order => 'sort_order')
    @creditworth = Creditworth.find(:all, :order => 'sort_order')
    @integrity = Integrity.find(:all, :order => 'sort_order')
    @timeliness = Timeliness.find(:all, :order => 'sort_order')
    @food = Food.find(@auction.food_id)
    @qualities = Quality.find(:all, :order => 'sort_order, name')
    @conditions = Condition.find(:all, :order => 'sort_order, name')
    @countries = Geographies::Country.find_by_region(@auction.origin_region_id)
    # GROWNS
    @growns = @food.growns
    if @growns.size == 0
      @growns = @food.parent.growns
    end
    if @growns.size == 0
      @growns = @food.parent.parent.growns
    end
    if @growns.size == 0
      @growns = @food.parent.parent.parent.growns
    end 
    # PACKS
    @packs = @food.packs
    if @packs.size == 0
      @packs = @food.parent.packs
    end
    if @packs.size == 0
      @packs = @food.parent.parent.packs
    end
    if @packs.size == 0
      @packs = @food.parent.parent.parent.packs
    end
    # PER_CASES
    @per_cases = @food.per_cases
    if @per_cases.size == 0
      @per_cases = @food.parent.per_cases
    end
    if @per_cases.size == 0
      @per_cases = @food.parent.parent.per_cases
    end 
    if @per_cases.size == 0
      @per_cases = @food.parent.parent.parent.per_cases
    end
    # SIZES   
    @sizes = @food.sizes
    if @sizes.size == 0
      @sizes = @food.parent.sizes
    end
    if @sizes.size == 0
      @sizes = @food.parent.parent.sizes
    end 
    if @sizes.size == 0
      @sizes = @food.parent.parent.parent.sizes
    end
    # WEIGHTS
    @weights = @food.weights
    if @weights.size == 0
      @weights = @food.parent.weights
    end
    if @weights.size == 0
      @weights = @food.parent.parent.weights
    end
    if @weights.size == 0
      @weights = @food.parent.parent.parent.weights
    end
    # COLORS
    @colors = @food.colors
    if @colors.size == 0
      @colors = @food.parent.colors
    end
    if @colors.size == 0
      @colors = @food.parent.parent.colors
    end
    if @colors.size == 0
      @colors = @food.parent.parent.parent.colors
    end
  end

  # send email alerts to buyers when a new auction is created
  def send_alerts(auction)
    food = Food.find(auction.food_id)
    watched_products = WatchedProduct.find_all_by_food_id(food.id)
    parent_products = WatchedProduct.find_all_by_food_id(food.parent_id)
    sent = Array.new
    parent_products.each do |notify|
      unless sent.include?(notify.user.email)
        if notify.user.email_confirmed
          AuctionMailer::deliver_buyer_alert(notify.user, auction)
        else
          AuctionMailer::deliver_nixie_buyer_alert(notify.user, auction)
        end
      end
      sent << notify.user.email
    end
    watched_products.each do |notify|
      unless sent.include?(notify.user.email)
        if notify.user.email_confirmed
          AuctionMailer::deliver_buyer_alert(notify.user, auction)
        else
          AuctionMailer::deliver_nixie_buyer_alert(notify.user, auction)
        end
      end
    end
    chat_alert('team', "sent #{sent.size} email alerts for buyers interested in #{auction.description}")
    chat_alert('user', "sent #{sent.size} email alerts for buyers interested in #{auction.description}")
  end
    
  # set the failure flag and set an error message
  def failure(err_msg)
    @fail = true
    @err_msg = err_msg
    # logger.info "\n\n #{err_msg} \n\n"
  end
end
