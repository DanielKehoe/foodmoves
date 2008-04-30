class PermissionsController < ApplicationController

  layout "admin"
  
  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager)'

  # GET /permissions/1;edit
  def edit
    @user = User.find(params[:user_id])
    @user_types = User.user_types
  end

  # PUT /permissions/1
  # PUT /permissions/1.xml
  def update
    @user = User.find(params[:user_id]) or raise ActiveRecord::RecordNotFound
    if (params[:user][:role_ids].nil?)
      flash[:error] = "Cannot remove access to all pages."
    else
      admin = Role.find_by_title('admin').id.to_s
      manager = Role.find_by_title('manager').id.to_s
      support = Role.find_by_title('support').id.to_s
      sales = Role.find_by_title('telesales').id.to_s
      member = Role.find_by_title('member').id.to_s
      guest = Role.find_by_title('guest').id.to_s
      my_roles = []
      for role in @current_user.roles
        my_roles << role.id.to_s
      end
      roles = params[:user][:role_ids]
      if (roles.include?(admin) && !my_roles.include?(admin)) then
        flash[:notice] = "You don't have authority to grant access to admin pages."
        redirect_to edit_permission_url(@user) 
      elsif (roles.include?(manager) && !my_roles.include?(manager)) then
        unless my_roles.include?(admin)
          flash[:notice] = "You don't have authority to grant access to manager pages."
          redirect_to edit_permission_url(@user) 
        else
          change_permissions(@user, roles, guest, member, support, sales, manager, admin)
        end
      elsif (roles.include?(support) && !my_roles.include?(support)) then
        unless my_roles.include?(admin)
          flash[:notice] = "You don't have authority to grant access to support pages."
          redirect_to edit_permission_url(@user) 
        else
          change_permissions(@user, roles, guest, member, support, sales, manager, admin)
        end
      elsif (roles.include?(sales) && !my_roles.include?(sales)) then
        unless my_roles.include?(admin)
          flash[:notice] = "You don't have authority to grant access to sales pages."
          redirect_to edit_permission_url(@user)
        else
            change_permissions(@user, roles, guest, member, support, sales, manager, admin)
        end
      elsif (roles.include?(member) && !my_roles.include?(member)) then
        unless my_roles.include?(admin)
          flash[:notice] = "You don't have authority to grant access to member pages."
          redirect_to edit_permission_url(@user) 
        else
          change_permissions(@user, roles, guest, member, support, sales, manager, admin)
        end
      elsif (@current_user.id == @user.id) then
        unless my_roles.include?(admin)
          flash[:notice] = "You can't change your own permissions."
          redirect_to edit_permission_url(@user) 
        else
          change_permissions(@user, roles, guest, member, support, sales, manager, admin)
        end
      else
        change_permissions(@user, roles, guest, member, support, sales, manager, admin)
      end
    end
  end
  
  private

  def change_permissions(user, roles, guest, member, support, sales, manager, admin)
    # If the user's permissions are updated their "of_type" attribute may need 
    # to change accordingly.
    if roles.include? guest : user.of_type = 'Guest'; end
    if roles.include? member : user.of_type = 'Member'; end
    if roles.include? support : user.of_type = 'Administrator'; end
    if roles.include? sales : user.of_type = 'Administrator'; end
    if roles.include? manager : user.of_type = 'Administrator'; end
    if roles.include? admin : user.of_type = 'Administrator'; end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "Successfully updated #{user.name}."
        format.html { redirect_to user_url(user) }
      else
        flash[:notice] = "Unable to update user #{user.name}."
        format.html { render :action => "edit" }
      end
    end
  end
end