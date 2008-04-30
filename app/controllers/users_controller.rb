class UsersController < ApplicationController

  layout "admin"
    
  # from acl_system2 example
  before_filter :login_required
  access_control [:show, :edit, :update] => 'member',
                  [:new, :create, :index ] => '(admin | manager | support | sales)',
                  [:destroy ] => '(admin | manager )'
    
  # for search function
  auto_complete_for :user, :email

  def set_flag
    @user = User.find(params[:id])
    if @user.update_attribute(:flag_for_user_id, params[:user][:flag_for_user_id])
      flash[:notice] = "Set flag for #{@user.name}."
    else
      flash[:error] = "Unable to set flag for #{@user.name}."
    end
    redirect_to :back
  end

  def delete_from_watchlist
    @watched_item = WatchedProduct.find(params[:id])
    name = @watched_item.description.nil? ? 'Item' : @watched_item.description
    WatchedProduct.delete(@watched_item)
    flash[:notice] = "Successfully deleted \"#{name}\" from email alerts."
    redirect_to :back
  end
      
  # Standard RESTful methods

  # GET /users
  # GET /users.xml
  def index
    if !params[:user].blank?
      unless params[:user][:email].blank?
        @users = User.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ['email = ?', params[:user][:email]], 
                                      :order => 'last_login_at DESC'
      else
        @users = User.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :order => 'last_login_at DESC'
      end
    elsif !params[:id].blank?
        @users = User.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ['id = ?', params[:id]],  
                                      :order => 'last_login_at DESC'
    elsif !params[:last_name].blank?
        @users = User.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ['last_name = ?', params[:last_name]],  
                                      :order => 'last_login_at DESC'
    elsif !params[:first_name].blank?
        @users = User.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ['first_name = ?', params[:first_name]],  
                                      :order => 'last_login_at DESC'
    elsif !params[:type].blank?
      case params[:type]
      when "buyers"
        @users = User.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ["of_type = 'Member' and starts_as = 'buyer'"],  
                                      :order => 'last_login_at DESC'
      when "sellers"
        @users = User.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ["of_type = 'Member' and starts_as = 'seller'"],  
                                      :order => 'last_login_at DESC'
      when "others"
        @users = User.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ["starts_as = 'other' and NOT of_type = 'Administrator'"],  
                                      :order => 'last_login_at DESC'
      when "members"
        @users = User.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ["of_type = 'Member'"],  
                                      :order => 'last_login_at DESC'
      when "guests"
        @users = User.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ["of_type = 'Guest'"],  
                                      :order => 'last_login_at DESC'
      when "nixies"
        @users = User.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ["last_login_at IS NULL"],  
                                      :order => 'created_at DESC'   
      when "staff"
        @users = User.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ["of_type = 'Administrator'"],  
                                      :order => 'last_login_at DESC'
      when "VIPs"
        @users = User.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ["flag_for_user_id = 1"],  
                                      :order => 'last_login_at DESC'
      when "redflagged"
        @users = User.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ["flag_for_user_id = 2"],  
                                      :order => 'last_login_at DESC'
      when "yellowflagged"
        @users = User.paginate :per_page => 20, 
                                     :page => params[:page],
                                     :conditions => ["flag_for_user_id = 3"],  
                                     :order => 'last_login_at DESC'
      when "unflagged"
        @users = User.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ["flag_for_user_id = 5"],  
                                      :order => 'last_login_at DESC'
      when "do_not_contact"
        @users = User.paginate :per_page => 20, 
                                     :page => params[:page],
                                     :conditions => ["do_not_contact = 1"],  
                                     :order => 'updated_at DESC'
      end                             
    else
      @users = User.paginate :per_page => 20, 
                                    :page => params[:page],
                                    :order => 'last_login_at DESC'
    end
    @flags = FlagForUser.find(:all, :order => "sort_order")
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @users.to_xml }
      format.csv {
        @users = Member.find :all, :order => 'updated_at DESC'
        render :text => @users.to_csv 
        response.headers['Content-Type'] = 'text/csv; charset=utf-8; header=present'
        response.headers['Content-Disposition'] = "attachment; filename=users_#{Time.now.strftime("%d-%m-%Y-%H-%M-%S")}.csv"
      }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id]) or raise ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @user.to_xml }
    end
  end

  # GET /users/new
  def new
    @user = User.new
    @user.industry_role = 42 # default is "produce buyer"
    @user.how_heard = 28 # default is "email from Foodmoves"
    @user.region_id = 9
    @user.country_id = 239
    @user.flag_for_user_id = 5 # default is "unflagged"
    set_up
    render :layout => 'admin_tabbed'
  end

  # GET /users/1;edit
  def edit
    @user = User.find(params[:id])
    if @user.flag_for_user_id.nil? then @user.flag_for_user_id = 5 end
    set_up
  end

  # POST /users
  # POST /users.xml
  # completes the invitation process for an admin to create a new user
  def create
    if params[:user][:email].blank?
      failure 'You did not enter a user email address.'
    else
      @user = User.find_by_email(params[:user][:email])
      if @user
        failure 'User already exists'
        exists = true
      else
        @user = User.new(params[:user])
        @user.flag_for_user_id = 5 # default is "unflagged"
        @user.of_type = 'Guest'
        prepare_invitation
      end
    end
    if @fail
      if exists
        set_up
        flash[:error] = @err_msg
        render :action => "edit"
      else 
        flash[:error] = @err_msg
        set_up
        render :action => "new"
      end
    else
      if @user.save
       unless params[:user][:food_grandparent_id].blank?
          @food = Food.find(params[:user][:food_grandparent_id])
          @watched_item = WatchedProduct.new(:user_id => @user.id,
                                              :description => @food.name,
                                              :food_id => @food.id) 
          @user.watched_products << @watched_item
          @user.save
        end
        begin
          InvitationMailer::deliver_new_buyer_invite(@user, @current_user, @watched_item)
        rescue
          raise Exception, "Added new user but unable to send email invitation."
        end
        flash[:notice] = "An invitation was sent to #{@user.email}. "
        chat_alert('team', "#{@current_user.name} sent a \"new buyer\" invitation to #{@user.email}")
        unless params[:user][:food_grandparent_id].blank?
          chat_alert('team', "and set a buyer alert for #{@food.name}")
        end
        set_up
        render :action => "new"
      else
        set_up
        render :action => "new"
      end
    end
  rescue Exception => e
    flash[:error] = "#{e}"
    redirect_to :back
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        unless params[:user][:food_grandparent_id].blank?
           @food = Food.find(params[:user][:food_grandparent_id])
           @watched_item = WatchedProduct.new(:user_id => @user.id,
                                               :description => @food.name,
                                               :food_id => @food.id) 
           @user.watched_products << @watched_item
           @user.save
         end
        flash[:notice] = "Successfully updated #{@user.name}."
        format.html { redirect_to user_url(@user) }
        format.xml  { head :ok }
      else
        if @user.flag_for_user_id.nil? then @user.flag_for_user_id = 5 end
        flash[:notice] = "Unable to update user #{@user.name}."
        set_up
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id]) or raise ActiveRecord::RecordNotFound
    auctions = Auction.find_all_by_seller_id(@user)
    purchases = Auction.find_all_by_buyer_id(@user)
    unless auctions.size > 0
      unless purchases.size > 0
        @user.destroy
        flash[:notice] = "Deleted user."
      else 
        flash[:error] = "#{@user.name} has made one or more purchases and cannot be deleted."
      end
    else 
      flash[:error] = "#{@user.name} has created one or more auctions and cannot be deleted."
    end
    redirect_to users_url
  end
  
  protected

  def permission_denied
    flash[:notice] = "You were denied access to the user accounts page."
    raise AccessDenied
  end
  
  private

  def set_up
    @flags = FlagForUser.find(:all, :order => "sort_order")
    @food = Food.find(:first)
    @food_root_children = Food.root.children
    @foods = Food.find(:all, :conditions => 'parent_id IS NOT NULL', :order => 'sort_order, name')
  end
  
  def prepare_invitation
    # If the guest is being created for the first time without a password
    # we automatically generate and encrypt a temporary password.
    @user.password = PhonemicPassword.generate(length=8)
    @user.password_confirmation = @user.password
    @user.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{@user.email}--")
    @user.crypted_password = @user.encrypt(@user.password)
    # the guest's record will show the current user sent the invitation
    @user.referred_by = @current_user.name
    @user.parent_id = @current_user.id
    @user.invitation_code = 'none'
  end
    
  # set the failure flag and set an error message
  def failure(err_msg)
    @fail = true
    @err_msg = err_msg
  end
end
