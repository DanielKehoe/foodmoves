class InvitationCodesController < ApplicationController

  layout "admin"

  # from acl_system2 example
  before_filter :login_required
  access_control [:index, :destroy] => '(admin | manager | support)'

  # replaced with Guests/new; no longer used here:
  # prepare an email message with an invitation code
  def invite
    flash[:notice] = "Sorry, that page is not available."
    redirect_to alerts_path
  end

  # replaced with Guests/create; no longer used here:
  # send an email with an invitation code
  def mail
    flash[:notice] = "Sorry, that page is not available."
    redirect_to alerts_path
  end
  
  # GET /invitation_codes
  # GET /invitation_codes.xml
  def index
    @invitation_codes = InvitationCode.paginate :per_page => 25, 
                                  :page => params[:page],
                                  :order => 'response_count DESC'
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @invitation_codes.to_xml }
    end
  end

  # GET /invitation_codes/1
  # GET /invitation_codes/1.xml
  def show
    @invitation_code = InvitationCode.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @invitation_code.to_xml }
    end
  end

  # GET /invitation_codes/new
  def new
    @invitation_code = InvitationCode.new
    @invitation_code.user_id = @current_user.id
    @invitation_code.role_id = Role.find_by_title('guest').id
    @invitation_code.code = @current_user.first_name.downcase.slice(0,1) + 
      @current_user.last_name.downcase + Time.now.month.to_s + Time.now.year.to_s.slice(2,4)
  end

  # GET /invitation_codes/1;edit
  def edit
    @invitation_code = InvitationCode.find(params[:id])
  end

  # POST /invitation_codes
  # POST /invitation_codes.xml
  def create
    @invitation_code = InvitationCode.new(params[:invitation_code])
    respond_to do |format|
      if @invitation_code.save
        flash[:notice] = 'Invitation Code was successfully created.'
        format.html { redirect_to invitation_code_url(@invitation_code) }
        format.xml  { head :created, :location => invitation_code_url(@invitation_code) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invitation_code.errors.to_xml }
      end
    end
  end

  # PUT /invitation_codes/1
  # PUT /invitation_codes/1.xml
  def update
    @invitation_code = InvitationCode.find(params[:id])
    respond_to do |format|
      if @invitation_code.update_attributes(params[:invitation_code])
        flash[:notice] = 'Invitation Code was successfully updated.'
        format.html { redirect_to invitation_code_url(@invitation_code) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invitation_code.errors.to_xml }
      end
    end
  end

  # DELETE /invitation_codes/1
  # DELETE /invitation_codes/1.xml
  def destroy
    @invitation_code = InvitationCode.find(params[:id])
    @invitation_code.destroy
    respond_to do |format|
      format.html { redirect_to invitation_codes_url }
      format.xml  { head :ok }
    end
  end
end
