class ReportsController < ApplicationController
  
  layout "admin"
    
  # from acl_system2 example
  before_filter :login_required
  access_control [:index ] => '(admin | manager | support | sales)'
    
  # Standard RESTful methods

  # GET /users
  # GET /users.xml
  def index
    if !params[:type].blank?
      case params[:type]
      when "buyers"
        respond_to do |format|
          format.html {
            @users = User.paginate :per_page => 500, 
                                          :page => params[:page],
                                          :conditions => ["of_type = 'Member' and starts_as = 'buyer'"],  
                                          :order => 'last_login_at DESC'     
          }
          format.csv {
            @users = User.find :all,
                                :conditions => ["of_type = 'Member' and starts_as = 'buyer'"],  
                                :order => 'last_login_at DESC'          
          }
        end
      when "sellers"
        respond_to do |format|
          format.html {
            @users = User.paginate :per_page => 500, 
                                          :page => params[:page],
                                          :conditions => ["of_type = 'Member' and starts_as = 'seller'"],  
                                          :order => 'last_login_at DESC'     
          }
          format.csv {
            @users = User.find :all,
                                :conditions => ["of_type = 'Member' and starts_as = 'seller'"],  
                                :order => 'last_login_at DESC'          
          }
        end
      when "others"
        respond_to do |format|
          format.html {
            @users = User.paginate :per_page => 500, 
                                          :page => params[:page],
                                          :conditions => ["starts_as = 'other' and NOT of_type = 'Administrator'"],  
                                          :order => 'last_login_at DESC'     
          }
          format.csv {
            @users = User.find :all,
                                :conditions => ["starts_as = 'other' and NOT of_type = 'Administrator'"],  
                                :order => 'last_login_at DESC'          
          }
        end
      when "members"
        respond_to do |format|
          format.html {
            @users = User.paginate :per_page => 500, 
                                          :page => params[:page],
                                          :conditions => ["of_type = 'Member'"],  
                                          :order => 'last_login_at DESC'     
          }
          format.csv {
            @users = User.find :all,
                                :conditions => ["of_type = 'Member'"],  
                                :order => 'last_login_at DESC'          
          }
        end
      when "guests"
        respond_to do |format|
          format.html {
            @users = User.paginate :per_page => 500, 
                                          :page => params[:page],
                                          :conditions => ["of_type = 'Guest'"],  
                                          :order => 'last_login_at DESC'     
          }
          format.csv {
            @users = User.find :all,
                                :conditions => ["of_type = 'Guest'"],  
                                :order => 'last_login_at DESC'          
          }
        end
      when "nixies"
        respond_to do |format|
          format.html {
            @users = User.paginate :per_page => 500, 
                                        :page => params[:page],
                                        :conditions => ["last_login_at IS NULL and of_type = 'Guest'"],  
                                        :order => 'created_at DESC'       
          }
          format.csv {
            @users = User.find :all,
                                :conditions => ["last_login_at IS NULL and of_type = 'Guest'"],  
                                :order => 'created_at DESC'          
          }
        end
      when "staff"
        @users = User.paginate :per_page => 500, 
                                      :page => params[:page],
                                      :conditions => ["of_type = 'Administrator'"],  
                                      :order => 'last_login_at DESC'
      when "VIPs"
        @users = User.paginate :per_page => 500, 
                                      :page => params[:page],
                                      :conditions => ["flag_for_user_id = 1"],  
                                      :order => 'last_login_at DESC'
      when "redflagged"
        @users = User.paginate :per_page => 500, 
                                      :page => params[:page],
                                      :conditions => ["flag_for_user_id = 2"],  
                                      :order => 'last_login_at DESC'
      when "yellowflagged"
        @users = User.paginate :per_page => 500, 
                                     :page => params[:page],
                                     :conditions => ["flag_for_user_id = 3"],  
                                     :order => 'last_login_at DESC'
      when "unflagged"
        @users = User.paginate :per_page => 500, 
                                      :page => params[:page],
                                      :conditions => ["flag_for_user_id = 5"],  
                                      :order => 'last_login_at DESC'
      when "do_not_contact"
        @users = User.paginate :per_page => 500, 
                                     :page => params[:page],
                                     :conditions => ["do_not_contact = 1"],  
                                     :order => 'updated_at DESC'
      end                             
    else
      respond_to do |format|
        format.html {
          @users = User.paginate :per_page => 500, 
                                      :page => params[:page],
                                      :order => 'last_login_at DESC'       
        }
        format.csv {
          @users = User.find :all,
                              :order => 'last_login_at DESC'          
        }
      end
    end
    @flags = FlagForUser.find(:all, :order => "sort_order")
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @users.to_xml(options = {}) }
      format.csv {
        render :text => @users.to_csv(:except => ['crypted_password', 'salt'])
        response.headers['Content-Type'] = 'text/csv; charset=utf-8; header=present'
        response.headers['Content-Disposition'] = "attachment; filename=users_#{Time.now.strftime("%d-%m-%Y-%H-%M-%S")}.csv"
      }
    end
  end
  
end
