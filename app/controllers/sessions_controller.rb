# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  layout "yui_t7_custom"

protected

  def ssl_required? 
    true
  end

public

  # display the login page
  def index
    redirect_to :action => :new
  end

  # display the login page
  def show
    redirect_to :action => :new
  end
  
  # display the login page
  def new
  end
  
  # start a new session and redirect to a home page
  def create
    begin
      self.current_user = User.authenticate(params[:email], params[:password])
    rescue AuthenticationError => e
      flash.now[:error] = "#{e}"
    end
    if logged_in?
      chat_alert('team', "#{self.current_user.of_type.downcase} #{self.current_user.name} is visiting the site")
      unless self.current_user.of_type.downcase == 'administrator'
        unless self.current_user.phones.empty?
          chat_alert('team', "#{self.current_user.name}'s phone number is " +
          "#{self.current_user.phones.first.number} " +
          "(#{self.current_user.phones.first.tag_for_phone})")
        else
          chat_alert('team', "sorry, I don't have a phone number for #{self.current_user.name}")
        end
      end
      unless self.current_user.email_confirmed
        chat_alert('team', "#{self.current_user.name} is visiting for the first time!")
        flash[:notice] = "Thanks for visiting Foodmoves. " +
                          "We'd like to set up your guest account. " +
                          "It's important to set a new password right now. " +
                          "And please tell us your name..."
        self.current_user.update_attribute(:email_confirmed, true)
        self.current_user.update_attribute(:last_login_at, Time.now)
        self.current_user.increment!('visits_count')
        if self.current_user.invitation_code then
          invitation = InvitationCode.find_by_code(self.current_user.invitation_code)
          if invitation
            invitation.response_count += 1
            invitation.save
          end
        else
          self.current_user.update_attribute(:invitation_code, 'self-invited')
        end
        redirect_to edit_guest_path(self.current_user)
      else
        if params[:remember_me] == "1"
          self.current_user.remember_me
          cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
        end
        self.current_user.update_attribute(:last_login_at, Time.now)
        self.current_user.increment!('visits_count')
        if permit?('admin') then 
          redirect_back_or_default admin_path
        elsif permit?('manager') then 
          redirect_back_or_default admin_path
        elsif permit?('telesales') then 
          redirect_back_or_default prospects_path()
        elsif permit?('support') then 
          redirect_back_or_default admin_path
        elsif permit?('member') then
          if self.current_user.starts_as == 'buyer'
            redirect_back_or_default home_path
          elsif self.current_user.starts_as == 'seller'
            redirect_back_or_default home_path
          else
            redirect_back_or_default home_path
          end
        else
          if self.current_user.starts_as == 'buyer'
            redirect_back_or_default home_path
          elsif self.current_user.starts_as == 'seller'
            redirect_back_or_default home_path
          else
            redirect_back_or_default home_path
          end        
        end
        if permit?('guest')
          flash.now[:notice] = "Your account is not affiliated with a company. " +
            "You can <a href=\"/buy\">browse</a> but you cannot buy or sell. " +
            "Would you like to <a href=\"/members/new\">set up trading?</a>"
        end
      end
    else
      render :action => 'new'
    end
  end

  def destroy
    name = self.current_user.name
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You've been logged out."
    chat_alert('team', "#{name} has left the site")
    redirect_to home_path
  end
end
