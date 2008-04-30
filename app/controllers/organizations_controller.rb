class OrganizationsController < ApplicationController
  
  include SslRequirement
    
  layout "admin"
  
  # from acl_system2 example
  before_filter :login_required
  access_control [:show, :edit, :update] => 'member',
                  [:new, :create, :index, :destroy ] => '(admin | manager | support)'
 
  #if PRODUCTION_SERVER
  if false
    ssl_required :edit
  end
  
  # for search function
  auto_complete_for :organization, :name
  
  # Standard RESTful methods

  # GET /organizations
  # GET /organizations.xml
  def index
    unless params[:organization].nil?
      @organizations = Organization.paginate :per_page => 20, 
                                    :page => params[:page],
                                    :conditions => ['name like ?', "%#{params[:organization][:name]}%"], 
                                    :order => 'updated_at DESC'
    else
      @organizations = Organization.paginate :per_page => 20, 
                                    :page => params[:page],
                                    :order => 'updated_at DESC'
    end                              
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @organizations.to_xml }
    end
  end

  # GET /organizations/1
  # GET /organizations/1.xml
  def show
    @organization = Organization.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @organization.to_xml }
    end
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
    @administrators = Administrator.find(:all, :order => "last_name")
  end

  # GET /organizations/1;edit
  def edit
    @organization = Organization.find(params[:id])
    @administrators = Administrator.find(:all, :order => "last_name")
    @creditworth = Creditworth.find(:all, :order => 'sort_order')
    @integrity = Integrity.find(:all, :order => 'sort_order')
    @timeliness = Timeliness.find(:all, :order => 'sort_order')
  end

  # POST /organizations
  # POST /organizations.xml
  def create
    @organization = Organization.new(params[:organization])
    respond_to do |format|
      if @organization.save
        flash[:notice] = 'Organization was successfully created.'
        format.html { redirect_to organization_url(@organization) }
        format.xml  { head :created, :location => organization_url(@organization) }
      else
        @administrators = Administrator.find(:all, :order => "last_name")
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization.errors.to_xml }
      end
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.xml
  def update
    @organization = Organization.find(params[:id])
    @card_info = CardInfo.new(params[:card_info])
    unless @card_info.missing?
      @card_info.organization_id = @organization.id
      begin
        @card_info.save!
      rescue Exception => e
        failure "#{e.message}"
      end
    end
    if @organization.update_attributes(params[:organization])
      flash[:notice] = 'Organization was successfully updated.'
    else
      failure 'Uanble to update Organization.'
    end
    unless @fail
      redirect_to organization_url(@organization)
    else
      @administrators = Administrator.find(:all, :order => "last_name")
      @creditworth = Creditworth.find(:all, :order => 'sort_order')
      @integrity = Integrity.find(:all, :order => 'sort_order')
      @timeliness = Timeliness.find(:all, :order => 'sort_order')
      flash[:error] = @err_msg
      render :action => "edit"
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.xml
  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to organizations_url }
      format.xml  { head :ok }
    end
  end
  
  private
  
  # set the failure flag and set an error message
  def failure(err_msg)
    @fail = true
    @err_msg = err_msg
  end
end
