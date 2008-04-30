class AffiliationsController < ApplicationController

  include SslRequirement
      
  # from acl_system2 example
  before_filter :login_required
  access_control [:show] => 'member',
                  [:index, :edit, :update] => '(admin | manager | support)',
                  [:destroy ] => '(admin | manager )'

  #if PRODUCTION_SERVER
  if false
    ssl_required :edit
  end
  
  def add_sell_approval
    @affiliation = Affiliation.find(params[:id])
    if @affiliation.update_attribute(:approved_to_sell, true)
      flash[:notice] = 'Affiliation was successfully updated.'
    else
      flash[:notice] = 'Could not update affiliation.'
    end
    redirect_to affiliation_url(@affiliation) 
  end

  def add_buy_approval
    @affiliation = Affiliation.find(params[:id])
    if @affiliation.update_attribute(:approved_to_buy, true)
      flash[:notice] = 'Affiliation was successfully updated.'
    else
      flash[:notice] = 'Could not update affiliation.'
    end
    redirect_to affiliation_url(@affiliation) 
  end
  
  def step_two_for_new
     @on_step_two = true
     @affiliation = Affiliation.find(params[:affiliation][:id])
     @organization = @affiliation.organization
     @creditworth = Creditworth.find(:all, :order => 'sort_order')
     @integrity = Integrity.find(:all, :order => 'sort_order')
     @timeliness = Timeliness.find(:all, :order => 'sort_order')
     @organization.update_attributes(params[:organization])
     # RENDER
     render :partial => 'form_two', :layout => false
   end

   def step_three_for_new
     @on_step_three = true
     @affiliation = Affiliation.find(params[:affiliation][:id])
     @organization = @affiliation.organization
     @organization.update_attributes(params[:organization])
     # RENDER
     render :partial => 'form_three', :layout => false
   end

   def step_four_for_new
     @on_step_four = true
     @affiliation = Affiliation.find(params[:affiliation][:id])
     @organization = @affiliation.organization
     @affiliation.called_by = @current_user.name
     # RENDER
     render :partial => 'form_four', :layout => false
   end
   
  # Standard RESTful methods

  # GET /affiliations
  # GET /affiliations.xml
  # Just for administrators, shows pending and recently approved affiliations.
  def index
    @pending_affiliations = Affiliation.find_all_not_approved
    @approved_affiliations = Affiliation.find_approved
    respond_to do |format|
      format.html { render :layout => 'admin' } # index.rhtml
      format.xml  { render :xml => @members.to_xml }
    end
  end
  
  # GET /affiliations/1
  # GET /affiliations/1.xml
  def show
    @affiliation = Affiliation.find(params[:id])

    respond_to do |format|
      format.html { render :layout => 'forms_narrow' }  # show.rhtml
      format.xml  { render :xml => @affiliation.to_xml }
    end
  end

  # GET /affiliations/1;edit
  def edit
    @on_step_two = false
    @on_step_three = false
    @on_step_four = false
    @affiliation = Affiliation.find(params[:id])
    @organization = @affiliation.organization
    @user = @affiliation.user
    @exists = Affiliation.find(:first,
              :conditions => "approved = 1 and user_id = #{@user.id} and organization_id = #{@organization.id}")
    render :layout => 'forms_narrow'  
  end

  # PUT /affiliations/1
  # PUT /affiliations/1.xml
  def update
    @affiliation = Affiliation.find(params[:id])
    @affiliation.called_by = @current_user.name
    @affiliation.reviewed_at = Time.now
    if @affiliation.approved_to_sell or @affiliation.approved_to_buy
      @affiliation.approved = true
    end
    @user = User.find(@affiliation.user_id)
    @organization = Organization.find(@affiliation.organization_id)
    if @affiliation.update_attributes(params[:affiliation])
      if @affiliation.approved = true
        unless @organization.phones.size == 0
          if @user.phones.nil?      
            @phone = Phone.new(
                            :phonable_id => @user.id,
                            :phonable_type => 'User',
                            :tag_for_phone => 'company',
                            :local_number => @organization.phones.first.local_number,
                            :locality_code => @organization.phones.first.locality_code,
                            :country_code => @organization.phones.first.country_code,
                            :region_id => @organization.phones.first.region_id)
            @phone.save
          end
        end
        unless @organization.addresses.size == 0
          if @user.addresses.nil?     
            @user_mailing_address = Address.new(
                            :addressable_id => @user.id,
                            :addressable_type => 'User',
                            :tag_for_address => 'office address',
                            :thoroughfare => @organization.addresses.first.thoroughfare,
                            :locality => @organization.addresses.first.locality,
                            :postal_code => @organization.addresses.first.postal_code,
                            :admin_area_id => @organization.addresses.first.admin_area_id,
                            :country_id => @organization.addresses.first.country_id,
                            :region_id => @organization.addresses.first.region_id)
            @user_mailing_address.save
          end
        end                          
        @user.of_type = 'Member'
        @user.save!
        @organization.of_type = 'Account'
        @organization.call_result = 'Set Up Trading'
        @organization.updated_by = @current_user.name
        @organization.save!
        @card_info = CardInfo.new(params[:card_info])
        unless @card_info.missing?
          @card_info.organization_id = @organization.id
          @card_info.save!
        end
        guest = Role.find_by_title('guest')
        guest.users.delete(@user)
        guest.save!
        member = Role.find_by_title('member')
        unless member.users.include?(@user)
          member.users << @user
          member.save!
        end
        flash[:notice] = "#{@user.name} was approved to trade. An email notice was sent."
        chat_alert('team', "#{@user.name} was approved to trade")
        begin
          InvitationMailer::deliver_approval(@user, @organization)
        rescue
          failure "#{@user.name} was approved to trade but couldn't send email notice."
        end
      else
        flash[:notice] = "#{@user.name} was NOT approved to trade. An email notice was sent."
        begin
          InvitationMailer::deliver_denial(@user, @organization, @affiliation)
        rescue
          failure "#{@user.name} was NOT approved to trade. Couldn't send an email notice."
        end
      end
    end
    if @fail
      @creditworth = Creditworth.find(:all, :order => 'sort_order')
      @integrity = Integrity.find(:all, :order => 'sort_order')
      @timeliness = Timeliness.find(:all, :order => 'sort_order')
      flash.now[:notice] = @err_msg
      logger.error "\n#{@err_msg}\n"
      render :layout => 'forms_narrow', :action => "edit"
    else
      redirect_to affiliations_url
    end
  end

  # DELETE /affiliations/1
  # DELETE /affiliations/1.xml
  def destroy
    @affiliation = Affiliation.find(params[:id]) or raise ActiveRecord::RecordNotFound
    @affiliation.destroy
    respond_to do |format|
      format.html { redirect_to affiliations_url }
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
