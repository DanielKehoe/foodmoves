class MembersController < ApplicationController
  
  # from acl_system2 example
  before_filter :login_required
  access_control [:index, :edit, :update ] => 'member',
                  :destroy => '(admin | manager | support)'

  def step_two_for_new
    @on_step_two = false
    unless params[:organization][:name].blank?
      @on_step_two = true
      @organization = Organization.new(params[:organization])
      @organization.name = @organization.name.titlecase
      @organizations = Organization.find(:all,
            :conditions => ["name like ?", @organization.name + "%" ],
            :order => "name ASC")
      if @organizations.size == 1
        @organization.id = @organizations.first.id
      end
      @phone = Phone.new
      @phone.country_id = '239'
    else
      flash.now[:error] = 'You did not enter a company name.'
    end
    # RENDER
    render :partial => 'form_two', :layout => false
  end

  def step_three_for_new
    @on_step_three = true
    unless params[:organization][:id].blank?
      @organization = Organization.find(params[:organization][:id])
    else
      @organization = Organization.new(params[:organization])
    end
    # RENDER
    render :partial => 'form_three', :layout => false
  end

  def step_four_for_new
    @on_step_four = true
    unless params[:organization][:id].blank?
      @organization = Organization.find(params[:organization][:id])
    else
      @organization = Organization.new(params[:organization])
    end
    @creditworth = Creditworth.find(:all, :order => 'sort_order')
    @integrity = Integrity.find(:all, :order => 'sort_order')
    @timeliness = Timeliness.find(:all, :order => 'sort_order')
    # RENDER
    render :partial => 'form_four', :layout => false
  end
  
  # Standard RESTful methods
                  
  # GET /members
  # GET /members.xml
  # Main page for a registered member.
  def index
    respond_to do |format|
      format.html { render :layout => 'yui_t7_custom' } # index.rhtml
      format.xml  { render :xml => @members.to_xml }
    end
  end

  # GET /members/1
  # GET /members/1.xml
  # Shows a member's user account details.
  def show
    support = Role.find_by_title('support')
    if @current_user.roles.include?(support)
      @member = User.find(params[:id])
    else
      @member = @current_user
    end
    @sales = Auction.find_sales(@member.id)
    @purchases = Bid.purchases(@member.id)
    @pending_pickups = Bid.pending_pickups(@member.id)
    @pending_affiliations = @member.affiliations.find_pending
    @approved_affiliations = @member.affiliations.find_approved
    @invitation_codes = InvitationCode.find_for_user(@member)
    @invitees = User.paginate :per_page => 10, 
                                :page => params[:page],
                                :conditions => ["parent_id = ?", @member],                               
                                :order => 'created_at DESC'
    respond_to do |format|
      format.html  { render :layout => 'sell' } # show.rhtml
      format.xml  { render :xml => @member.to_xml }
    end
  end

  # GET /members/new
  def new
    # Used when a guest upgrades to become a member.
    @on_step_two = false
    @on_step_three = false
    @on_step_four = false
    @organization = Organization.new
    render :layout => 'forms_narrow'
  end

  # GET /members/1;edit
  def edit
    # Used by a member to change account details.
    @member = @current_user
  end

  # POST /members
  # POST /members.xml
  # Used when a guest requests an upgrade to become a member. Creates a new Affiliation.
  def create
    @member = @current_user
    unless params[:organization][:id].blank?
      @organization = Organization.find(params[:organization][:id])
    else
      @organization = Organization.new(params[:organization])
      @phone = Phone.new(params[:phone])
      @phone.phonable_type = 'Organization'
      @phone.tag_for_phone = 'main'
      @organization.phones << @phone
      @organization.created_by = @member.id
      @organization.save!
    end
    exists = Affiliation.find(:first,
              :conditions => "user_id = #{@current_user.id} and organization_id = #{@organization.id}")
    if exists
      failure "Request rejected. #{@current_user.name} already requested affiliation " +
            "with #{@organization.name}. You can check the status by asking in " +
            "<a href=\"http://foodmoves.campfirenow.com/e08e3\" " +
            "onclick=\"window.open(this.href,'Chat','width=650,height=1000');return false;\">chat</a>."
    else 
      @affiliation = Affiliation.new(
                          :user_id => @current_user.id,
                          :organization_id => @organization.id)
      if @affiliation.save
        begin
          InvitationMailer::deliver_affiliation(@current_user, @organization)
          AdminMailer::deliver_affiliation(@current_user, @organization, @affiliation)
        rescue
          failure "Affiliation entered but unable to send email notification."
        end
        flash[:notice] = "Within the next business day, our support team will
                          contact #{@organization.name} 
                          to verify that you are authorized to trade."
        chat_alert('team', "#{@current_user.name} wants to get set up for trading")
      else
        failure "Unable to submit request for affiliation."
      end
    end
    unless @fail
      redirect_to member_url(@member)
    else
      flash[:error] = @err_msg  
      redirect_to :back    
    end
  end

  # PUT /members/1
  # PUT /members/1.xml
  def update
    @member = Member.find(params[:id])
    respond_to do |format|
      if @member.update_attributes(params[:member])
        flash[:notice] = 'Member was successfully updated.'
        format.html { redirect_to member_url(@member) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member.errors.to_xml }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.xml
  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url }
      format.xml  { head :ok }
    end
  end
  
  
  # set the failure flag and set an error message
  def failure(err_msg)
    @fail = true
    @err_msg = err_msg
  end
end
