class AddressesController < ApplicationController
  
  include GeoKit::IpGeocodeLookup
  
  layout "admin"
  
  # from acl_system2 example
  before_filter :login_required
  access_control [:index, :destroy] => '(admin | manager | support)'
  
  # for search function
  auto_complete_for :address, :locality
  
  # Standard RESTful methods

  # GET /addresses
  # GET /addresses.xml
  def index
    @address = Address.new
    unless params[:address].nil?
      unless params[:address][:locality].nil?
        @addresses = Address.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ['locality like ?', "%#{params[:address][:locality]}%"], 
                                      :order => 'updated_at DESC'
      end
      unless params[:address][:region_id].nil?
        @address.region_id = params[:address][:region_id]
        @addresses = Address.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ['region_id = ?', @address.region_id], 
                                      :order => 'updated_at DESC'
      end
      unless params[:address][:country_id].nil?
        @address.country_id = params[:address][:country_id]
        @addresses = Address.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ['country_id = ?', @address.country_id], 
                                      :order => 'updated_at DESC'
      end
      unless params[:address][:admin_area_id].nil?
        @address.admin_area_id = params[:address][:admin_area_id]
        @addresses = Address.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ['admin_area_id = ?', @address.admin_area_id], 
                                      :order => 'updated_at DESC'
      end                                
    else
      @addresses = Address.paginate :per_page => 20, 
                                    :page => params[:page],
                                    :order => 'updated_at DESC'
    end                                
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @addresses.to_xml }
      format.csv {
        @addresses = Address.find :all, :order => 'updated_at DESC'
        render :text => @addresses.to_csv 
        response.headers['Content-Type'] = 'text/csv; charset=utf-8; header=present'
        response.headers['Content-Disposition'] = "attachment; filename=addresses_#{Time.now.strftime("%d-%m-%Y-%H-%M-%S")}.csv"
      }
    end
  end

  # GET /addresses/1
  # GET /addresses/1.xml
  def show
    @address = Address.find(params[:id])
    if @address.lat? && @address.lng?
      # use the YM4R/GM plugin to generate a map
      @map = GMap.new("mini_map")
      @map.control_init(:small_map => true)
      @map.center_zoom_init([@address.lat,@address.lng],15)
      @map.overlay_init(GMarker.new([@address.lat,@address.lng]))
    end
    respond_to do |format|
      format.html { render :layout => 'admin_map' }# show.rhtml
      format.xml  { render :xml => @address.to_xml }
    end
  end

  # GET /addresses/new
  def new
    if params[:user_id]
      @address = Address.new(:addressable_type => 'User', :addressable_id => params[:user_id])
      @name = User.find(params[:user_id]).name
    else
      @address = Address.new(:addressable_type => 'Organization', :addressable_id => params[:organization_id])
      @name = Organization.find(params[:organization_id]).name
    end
    @address_tags = TagForAddress.find(:all, :order => "sort_order, name")
    # set default country based on current user country
    if @current_user.country_id
      @address.country_id = @current_user.country_id
    end
    # guess city and state using IP lookup (only for US locations)
    @location = GeoKit::Geocoders::IpGeocoder.geocode(request.remote_ip)
    if @location.success
      if @location.city == "(Unknown City)"
        @address.locality = ''
      else
        @address.locality = @location.city
        if @location.is_us?
          @address.country_id = Geographies::Country.find_by_code('US')
        end
      end
    end
  end

  # GET /addresses/1;edit
  def edit
    @address = Address.find(params[:id])
    @address_tags = TagForAddress.find(:all, :order => "sort_order, name")
  end

  # POST /addresses
  # POST /addresses.xml
  def create
    @address = Address.new(params[:address])
    respond_to do |format|
      if @address.save
        flash[:notice] = "Successfully added #{@address.thoroughfare}."
        format.html { redirect_to address_path(@address) }
        format.xml  { head :created, :location => address_url(@address) }
      else
        flash[:notice] = "Unable to add #{@address.thoroughfare}."
        format.html { render :action => "new" }
        format.xml  { render :xml => @address.errors.to_xml }
      end
    end
  end

  # PUT /addresses/1
  # PUT /addresses/1.xml
  def update
    @address = Address.find(params[:id])
    respond_to do |format|
      if @address.update_attributes(params[:address])
        flash[:notice] = "#{@address.thoroughfare} was successfully updated."
        format.html { redirect_to address_url(@address) }
        format.xml  { head :ok }
      else
        flash[:notice] = "Unable to update #{@address.thoroughfare}."
        format.html { render :action => "edit" }
        format.xml  { render :xml => @address.errors.to_xml }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.xml
  def destroy
    @address = Address.find(params[:id])
    auctions = Auction.find_all_by_address_id(@address)
    unless auctions.size > 0
      @address.destroy
      flash[:notice] = "Deleted address."
    else 
      flash[:error] = "The address in #{@address.city_state} is in use for one or more auctions and cannot be deleted."
    end
    redirect_to addresses_url
  end
  
  private
  
  # set the failure flag and set an error message
  def failure(err_msg)
    @fail = true
    @err_msg = err_msg
  end
  
end
