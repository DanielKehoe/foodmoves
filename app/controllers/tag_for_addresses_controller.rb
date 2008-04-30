class TagForAddressesController < ApplicationController
  
  layout "admin"
  
  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager)'
  
  # Standard RESTful methods
  
  # GET /tag_for_addresses
  # GET /tag_for_addresses.xml
  def index
    @tag_for_addresses = TagForAddress.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @tag_for_addresses.to_xml }
    end
  end

  # GET /tag_for_addresses/1
  # GET /tag_for_addresses/1.xml
  def show
    @tag_for_address = TagForAddress.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @tag_for_address.to_xml }
    end
  end

  # GET /tag_for_addresses/new
  def new
    @tag_for_address = TagForAddress.new
  end

  # GET /tag_for_addresses/1;edit
  def edit
    @tag_for_address = TagForAddress.find(params[:id])
  end

  # POST /tag_for_addresses
  # POST /tag_for_addresses.xml
  def create
    @tag_for_address = TagForAddress.new(params[:tag_for_address])

    respond_to do |format|
      if @tag_for_address.save
        flash[:notice] = "Successfully created #{@tag_for_address.name}."
        format.html { redirect_to tag_for_address_url(@tag_for_address) }
        format.xml  { head :created, :location => tag_for_address_url(@tag_for_address) }
      else
        flash[:notice] = "Unable to create #{@tag_for_address.name}."
        format.html { render :action => "new" }
        format.xml  { render :xml => @tag_for_address.errors.to_xml }
      end
    end
  end

  # PUT /tag_for_addresses/1
  # PUT /tag_for_addresses/1.xml
  def update
    @tag_for_address = TagForAddress.find(params[:id])

    respond_to do |format|
      if @tag_for_address.update_attributes(params[:tag_for_address])
        flash[:notice] = "Successfully updated #{@tag_for_address.name}."
        format.html { redirect_to tag_for_address_url(@tag_for_address) }
        format.xml  { head :ok }
      else
        flash[:notice] = "Unable to update #{@tag_for_address.name}."
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tag_for_address.errors.to_xml }
      end
    end
  end

  # DELETE /tag_for_addresses/1
  # DELETE /tag_for_addresses/1.xml
  def destroy
    @tag_for_address = TagForAddress.find(params[:id])
    @tag_for_address.destroy

    respond_to do |format|
      format.html { redirect_to tag_for_addresses_url }
      format.xml  { head :ok }
    end
  end
end
