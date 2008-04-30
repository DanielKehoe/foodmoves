# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  # include ExceptionNotifiable

  class AccessDenied < StandardError; end
  class ActionDenied < StandardError; end

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_trunk_session_id'

  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  
  # for use with Globalize plugin
  before_filter :set_locale

  around_filter :set_timezone
  around_filter :catch_errors
  
  # for the Exception Notifier plugin, show full error messages on the staging server
  # consider_local "65.74.151.127"
  
  protected
    def self.protected_actions
      [ :edit, :update, :destroy ]
    end

    def permission_denied
      raise AccessDenied
    end

    def chat_alert(chatroom, message)
      begin
        campfire = Tinder::Campfire.new 'foodmoves'
        unless campfire.nil?
          campfire.login 'nanabot@foodmoves.com', '4roper2c'
          case chatroom
            when "team"
             room = campfire.find_room_by_name 'Foodmoves Team'
            when "user"
              room = campfire.find_room_by_name 'Foodmoves Users'
          end
          unless room.nil?
            if PRODUCTION_SERVER
              room.speak message
            end
          end
        else
          # logger.info "\n\n can't obtain campfire login\n\n"
        end
      rescue Tinder::Error => e
        # logger.info "\n\n #{e} \n\n"
      end
    end
        
  private

    def set_timezone
      if logged_in? && !current_user.time_zone.nil?
        TzTime.zone = current_user.tz
      else
        TzTime.zone = TZInfo::Timezone.new('America/Chicago')
      end
      yield
      TzTime.reset!
    end

    def catch_errors
      begin
        yield
      rescue ActionDenied
        flash.now[:error] = flash[:error] + " " + "You do not have permission to do that."
        redirect_to alerts_path
      rescue AccessDenied
        if permit?('guest')
          flash.now[:notice] = "Your account is not affiliated " +
            "with a company. " +
            "You can <a href=\"/buy\">browse</a> but you cannot buy or sell. " +
            "Would you like to <a href=\"/members/new\">set up trading?</a>"
        else
          if flash[:error]
            flash[:error] = flash[:error] + " " + "You were denied " +
                                                  " access to that feature."
          else
            flash[:error] = "You were denied access to that feature."
          end
        end
        redirect_to alerts_path
      rescue ActiveRecord::RecordNotFound
        flash[:error] = "Sorry, can't find a match in our database."
        if request.env["HTTP_REFERER"] then redirect_to :back else redirect_to alerts_path end
      end
    end
    
    # for use with Globalize plugin
    # Set the locale from the parameters, the session, the HTTP headers, or default to 'en-US'
    def set_locale
      request_language = request.env['HTTP_ACCEPT_LANGUAGE']
      request_language = request_language.nil? ? nil : request_language[/[^,;]+/]
      @locale = params[:locale] || session[:locale] || request_language || DEFAULT_LOCALE
      session[:locale] = @locale
      begin
        Locale.set @locale
      rescue
        Locale.set DEFAULT_LOCALE
      end
    end
end
