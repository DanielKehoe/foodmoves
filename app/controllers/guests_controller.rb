class GuestsController < ApplicationController

  layout 'forms_narrow'
  
  # from acl_system2 example
  # after "session/new", they would go to "session/show" 
  # but "login required" for "show" sends them to a different page
  before_filter :login_required, :except => [:index, :new, :create, :confirm, :update, :edit]
  access_control [:destroy] => '(admin | manager | support)'

  # for search function
  auto_complete_for :guest, :email
  
  # GET /guests/invite_again
  # Form to re-invite a user.
  def invite_again
    @guest = Guest.new
    @sent_already = true
    if logged_in?
      unless params[:id].nil?
        @guest = User.find(params[:id])
      end
      @message = "Here's your invitation to visit Foodmoves. " +
                  "Please let me know that you got this message."
    end
    render :action => 'new', :layout => 'yui_t7_custom'
  end
  
  # GET /guests
  # GET /guests.xml
  def index
    flash[:notice] = "Sorry, that page is not available."
    redirect_to alerts_path
  end

  # GET /guests/1
  # GET /guests/1.xml
  def show
    flash[:notice] = "Sorry, that page is not available."
    redirect_to alerts_path
  end

  # GET /guests/new
  # Form to sign up a new visitor as a guest.
  def new
    @guest = Guest.new
    if logged_in?
      unless params[:id].nil?
        @invitation_code = InvitationCode.find(params[:id])
        unless @invitation_code.nil?
          @guest.invitation_code = @invitation_code.code
          unless @current_user.id == @invitation_code.user_id
            flash[:error] = "You are not allowed to use an invitation code created by someone else."
          end
        end
      end
      @message = "Here's your invitation to visit Foodmoves. " +
                  "Please let me know that you got this message."
    end
    render :layout => 'yui_t7_custom'
  end

  # GET /guests/1;edit
  # Used by a guest after their email address is confirmed, to input name, country, etc.
  def edit
    begin
      @guest = Guest.find(params[:id])
      @guest.set_up_trading = false
    rescue
      flash.now[:error] = "User not found. Perhaps " +
                          "the guest has already visited and set up an account? " +
                          "If you need help, you can ask in " +
                          "<a href=\"http://foodmoves.campfirenow.com/e08e3\" " +
                          "onclick=\"window.open(this.href,'Chat','width=650,height=1000');return false;\">chat</a>."
    end
  end

  # POST /guests
  # POST /guests.xml
  # Process form to sign up a new visitor as a guest and email an invitation
  def create
    email = params[:guest][:email]
    if email.blank?
      raise Exception, "The email address was blank."
    end
    if User.spamming_invitations?(@current_user) or User.spamming_reinvitations?(@current_user)    
      AdminMailer::deliver_spam_alert(@current_user)
      raise Exception, "You've sent too many invitations in the last fifteen minutes. " +
        "Your account will be suspended if you continue!"
    end
    if User.ignored_spamming_invitations_alert?(@current_user) or User.ignored_spamming_reinvitations_alert?(@current_user)    
      @current_user.update_attribute(:blocked, true)
      @current_user.forget_me if logged_in?
      cookies.delete :auth_token
      reset_session
      flash[:notice] = "You've been logged out."
      redirect_to news_path
      AdminMailer::deliver_account_suspended_alert(@current_user)
      return
    end
    @guest = User.find_by_email(email)
    unless @guest
      @guest = Guest.new(params[:guest])
    else
      if @guest.email_confirmed
        unless logged_in?
          raise Exception, "Sorry, it appears #{@guest.email} " +
            "has already visited the site. If you need help, you can ask in " +
            "<a href=\"http://foodmoves.campfirenow.com/e08e3\" " +
            "onclick=\"window.open(this.href,'Chat','width=650,height=1000');return false;\">chat</a>."   
        else
          unless params[:replace_password] == 'true'
            @visited_already = true
            raise Exception, "Sorry, it appears #{@guest.email} " +
              "has already visited the site."
          else
            @guest.email_confirmed = nil
          end  
        end
      else
        unless params[:send_again] == 'true'
          @sent_already = true
          raise Exception, "Someone already sent an invitation on #{@guest.created_at}. " +
            "Would you like to send another invitation?"
        else
          @guest.invited_again_at = Time.now
          logger.info "\n\n@guest.email invited again at #{@guest.invited_again_at}\n\n"     
        end
      end     
    end
    prepare_invitation
    if @guest.save
      if @guest.invitation_code then
        invitation = InvitationCode.find_by_code(@guest.invitation_code)
        if invitation
          invitation.sent_count += 1
          invitation.save
        end
      end
      unless logged_in?
        InvitationMailer::deliver_signup(@guest)
        flash[:notice] = "An invitation was sent to #{@guest.email}. " +
                          "<br /><br/>" +
                          "Check your email. " +
                          "<br /><br/>" +
                          "And make sure the invitation is not lost in your junk mail."
        chat_alert('team', "an invitation was sent to #{@guest.email}")
        redirect_to alerts_path
      else
        if params[:replace_password] == 'true'
          @guest.update_attribute(:email_confirmed, nil)
        end
        InvitationMailer::deliver_invite(@guest, params[:message], @current_user)
        flash[:notice] = "An invitation was sent to #{@guest.email}. "
        chat_alert('team', "#{@current_user.name} sent an invitation to #{@guest.email}")
        redirect_to member_path(@current_user)      
      end
    else
      raise Exception, "Couldn't send invitation to #{@guest.email}."
    end
  rescue Exception => e
    flash.now[:error] = "#{e}"
    render :layout => 'yui_t7_custom', :action => "new" 
  end

  # PUT /guests/1
  # PUT /guests/1.xml
  # Takes name, country, etc. from the "edit" page and updates the Guest instance.
  # The guest encounters the "edit" page after responding to an emailed invitation.
  def update
    @guest = User.find(params[:id])
    if params[:guest][:last_name].blank?
      raise Exception, "Please enter your first and last name." 
    end
    unless params[:guest][:accept_terms] == "1"
      raise Exception, "Please check the box to agree to the web site rules." 
    end
    # was an invitation code used by someone to invite this guest?
    unless params[:guest][:invitation_code].blank?
      # the new guest may have been given an invitation code offline
      begin 
        invitation_code = params[:guest][:invitation_code]
        invitation = InvitationCode.find_by_code(invitation_code) or raise ActiveRecord::RecordNotFound
        @guest.parent_id = invitation.user_id
        @guest.referred_by = User.find(invitation.user_id).name
      rescue ActiveRecord::RecordNotFound
        # if we don't recognize the invitation code, don't save it
        params[:guest][:invitation_code] = nil
        # if we can't find an invitation code, maybe we'll recognize an email address
        unless params[:guest][:referred_by].blank?
          referred_by = params[:guest][:referred_by]
          referring_user = User.find_by_email(referred_by)
          if ( referring_user )
            @guest.parent_id = referring_user.id
            @guest.referred_by = referring_user.name
          end
        end
      end  
    end
    params[:guest][:how_heard] = '37'
    if @guest.update_attributes(params[:guest]) 
      if params[:guest][:set_up_trading] == "true"
        redirect_to new_member_path()
      else
        flash[:notice] = "We've set up your guest account for browsing."
        redirect_to buy_path()
      end
    else
      raise Exception, "Couldn't save information for your guest account."
    end
  rescue Exception => e
    flash.now[:error] = "#{e}"
    render :action => "edit" 
  end

  # DELETE /guests/1
  # DELETE /guests/1.xml
  # RESTRICTED to the administrators by the access_control handler.
  def destroy
    @guest = Guest.find(params[:id])
    @guest.destroy

    respond_to do |format|
      format.html { redirect_to guests_url }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def prepare_invitation
    # If the guest is being created for the first time without a password
    # we automatically generate and encrypt a temporary password.
    @guest.password = PhonemicPassword.generate(length=8)
    @guest.password_confirmation = @guest.password
    @guest.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{@guest.email}--")
    @guest.crypted_password = @guest.encrypt(@guest.password)
    if logged_in?
      # the guest's record will show the current user sent the invitation
      @guest.referred_by = @current_user.name
      @guest.parent_id = @current_user.id
      # we'll guess the guest is from the same country as the current user
      @guest.region_id = @current_user.region_id
      @guest.country_id = @current_user.country_id
      unless @guest.invitation_code.blank?
        @invitation_code = InvitationCode.find_by_code(@guest.invitation_code)
      else
        @guest.invitation_code = 'none'
      end
    end
  end
  
end
