class CardInfosController < ApplicationController

  layout "admin"

  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager | support)'

  # Standard RESTful methods

  # GET /card_infos/1;edit
  def edit
    @card_info = CardInfo.find(params[:id])
    @organization = Organization.find(@card_info.organization_id)
  end

  # PUT /card_infos/1
  # PUT /card_infos/1.xml
  def update
    @card_info = CardInfo.find(params[:id])
    @organization = Organization.find(@card_info.organization_id)
    if @card_info.update_attributes(params[:card_info])
      flash[:notice] = "Successfully updated credit card for #{@organization.name}."
      redirect_to organization_url(@organization)
    else
      flash[:notice] = "Unable to update credit card for #{@organization.name}."
      render :action => "edit"
    end
  end

  # DELETE /card_infos/1
  # DELETE /card_infos/1.xml
  def destroy
    @card_info = CardInfo.find(params[:id])
    @organization = Organization.find(@card_info.organization_id)
    @card_info.destroy
    redirect_to organization_url(@organization)
  end
  
  private
  
  # set the failure flag and set an error message
  def failure(err_msg)
    @fail = true
    @err_msg = err_msg
    logger.info "\n\n#{@err_msg}\n\n"
  end
end
