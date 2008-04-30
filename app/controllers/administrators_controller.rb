class AdministratorsController < ApplicationController
  
  layout "admin"

  # if there are no users, let the first visitor create a new administrator
  before_filter :login_required, :except => [:new, :create]
  access_control [:index, :edit, :show, :update] => '(admin | manager | support)',
                  :destroy => 'admin'

  # GET /administrators
  # GET /administrators.xml
  def index
    @administrators = Administrator.find(:all, 
                  :order => "updated_at DESC")
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @administrators.to_xml }
    end
  end

  # GET /administrators/1
  # GET /administrators/1.xml
  def show
    @administrator = Administrator.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @administrator.to_xml }
    end
  end

  # GET /administrators/new
  def new
    begin
      # is a user already in the database?
      user = User.find(:first) or raise ActiveRecord::RecordNotFound
      flash[:notice] = "An administrator already exists. You can't create one."
      logger.info "\n\nAn administrator already exists. Can't create one.\n\n"
      redirect_to home_url
    rescue
      # if there are no users in the database, let the visitor create an administrator
      @administrator = Administrator.new
      render(:layout => false)
    end
  end

  # GET /administrators/1;edit
  def edit
    @administrator = Administrator.find(params[:id])
  end

  # POST /administrators
  # POST /administrators.xml
  def create
    @administrator = Administrator.new(params[:administrator])
    respond_to do |format|
      if @administrator.save
        guest = Role.find_by_title('guest')
        admin = Role.find_by_title('admin')
        manager = Role.find_by_title('manager')
        support = Role.find_by_title('support')
        member = Role.find_by_title('member')
        @administrator.roles << guest
        @administrator.roles << member
        @administrator.roles << support
        @administrator.roles << manager
        @administrator.roles << admin
        flash[:notice] = 'Successfully created a new administrator.'
        format.html { redirect_to admin_url() }
        format.xml  { head :created, :location => administrator_url(@administrator) }
      else
        flash[:notice] = "Couldn't create a new administrator."
        format.html { render :action => "new" }
        format.xml  { render :xml => @administrator.errors.to_xml }
      end
    end
  end

  # PUT /administrators/1
  # PUT /administrators/1.xml
  def update
    @administrator = Administrator.find(params[:id])

    respond_to do |format|
      if @administrator.update_attributes(params[:administrator])
        flash[:notice] = 'Administrator was successfully updated.'
        format.html { redirect_to administrator_url(@administrator) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @administrator.errors.to_xml }
      end
    end
  end

  # DELETE /administrators/1
  # DELETE /administrators/1.xml
  def destroy
    @administrator = Administrator.find(params[:id])
    @administrator.destroy

    respond_to do |format|
      format.html { redirect_to administrators_url }
      format.xml  { head :ok }
    end
  end
end
