class WatchedLocationsController < ApplicationController
  
  layout "admin"
  
  # from acl_system2 example
  before_filter :login_required

  # Standard RESTful methods

  # GET /watched_locations
  # GET /watched_locations.xml
  def index
    support = Role.find_by_title('support')
    if @current_user.roles.include?(support) then     
      @watched_locations = WatchedLocation.paginate :per_page => 20, 
                                    :page => params[:page],
                                    :conditions => ['locality like ?', "%#{params[:search]}%"], 
                                    :order => "region_id, country_id, admin_area_id, locality"
    else
      @watched_locations = WatchedLocation.paginate :per_page => 20, 
                                    :page => params[:page],
                                    :conditions => ["user_id = :id", { id => @current_user.id } ],
                                    :order => "region_id, country_id, admin_area_id, locality" 
    end
    respond_to do |format|
      format.html # index.rhtml
    end
  end

  # GET /watched_locations/1
  # GET /watched_locations/1.xml
  def show
    @watched_location = WatchedLocation.find(params[:id])
    if @watched_location.lat? && @watched_location.lng?
      # use the YM4R/GM plugin to generate a map
      @map = GMap.new("mini_map")
      @map.control_init(:small_map => true)
      @map.center_zoom_init([@watched_location.lat,@watched_location.lng],15)
      @map.overlay_init(GMarker.new([@watched_location.lat,@watched_location.lng]))
    end
    respond_to do |format|
      format.html { render :layout => 'admin_map' }# show.rhtml
      format.xml  { render :xml => @watched_location.to_xml }
    end
  end

  # GET /watched_locations/new
  def new
    @watched_location = WatchedLocation.new(:user_id => @current_user.id)
    # set default region and country based on current user region and country
    if @current_user.region_id then @watched_location.region_id = @current_user.region_id end
    if @current_user.country_id then @watched_location.country_id = @current_user.country_id end
    # set default location based on current user primary address
    if @current_user.addresses.first
      address = @current_user.addresses.first
      @watched_location.region_id = address.region_id
      @watched_location.country_id = address.country_id
      @watched_location.admin_area_id = address.admin_area_id
      @watched_location.locality = address.locality
    end
  end

  # GET /watched_locations/1;edit
  def edit
    @watched_location = WatchedLocation.find(params[:id])
  end

  # POST /watched_locations
  # POST /watched_locations.xml
  def create
    @watched_location = WatchedLocation.new(params[:watched_location])
    @watched_location.user_id = @current_user.id
    respond_to do |format|
      if @watched_location.save
        flash[:notice] = "Successfully added #{@watched_location.locality}."
        format.html { redirect_to buy_path }
        format.xml  { head :created, :location => watched_location_url(@watched_location) }
      else
        if params[:watched_location][:locality].blank?
          flash[:notice] = "You must provide a city."
        else
          flash[:notice] = "Unable to add this location."
        end
        format.html { render :action => "new" }
        format.xml  { render :xml => @watched_location.errors.to_xml }
      end
    end
  end

  # PUT /watched_locations/1
  # PUT /watched_locations/1.xml
  def update
    @watched_location = WatchedLocation.find(params[:id])
    respond_to do |format|
      if @watched_location.update_attributes(params[:watched_location])
        flash[:notice] = "#{@watched_location.locality} was successfully updated."
        format.html { redirect_to watched_location_url(@watched_location) }
        format.xml  { head :ok }
      else
        flash[:notice] = "Unable to update this location."
        format.html { render :action => "edit" }
        format.xml  { render :xml => @watched_location.errors.to_xml }
      end
    end
  end

  # DELETE /watched_locations/1
  # DELETE /watched_locations/1.xml
  def destroy
    @watched_location = WatchedLocation.find(params[:id])
    @watched_location.destroy
    respond_to do |format|
      format.html { redirect_to buy_url }
      format.xml  { head :ok }
    end
  end
end
