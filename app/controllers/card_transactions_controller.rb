class CardTransactionsController < ApplicationController

  layout "admin"

  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager | support)'

  # Standard RESTful methods
  
  def new
    @invoice = Invoice.find(params[:id])
    @organization = Organization.find(@invoice.user.organizations.first.id)
    @buyer = User.find(@invoice.buyer_id)
  end
  
  def create
    @invoice = Invoice.find(params[:card_transaction][:id])
    @organization = Organization.find(@invoice.user.organizations.first.id)
    right_now = Time.now
    credit_card = @organization.card_info.creditcard(params[:card_transaction][:pass_phrase])
    gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
      :login  => '8zC26PftE',
      :password => '82e69aTF2hQyb6QZ')
    response = gateway.purchase((@invoice.due_foodmoves * 100), credit_card)
    if response.success?
      if @invoice.update_attributes(:date_billed => right_now,
                                    :date_paid => right_now)
        flash[:notice] = "Successfully charged #{@organization.name} for auction #{@invoice.id}."
      else
        failure "Charged #{@organization.name} for auction #{@invoice.id} but unable to update database."
      end
    else
      failure "Credit card error reported by Authorize.net: #{response.message}"
    end
    if @fail
      flash[:error] = @err_msg
    end
    redirect_to invoices_url
  rescue Exception => e
    flash[:error] = "#{e}"
    redirect_to invoices_url
  end
  
  private
  
  # set the failure flag and set an error message
  def failure(err_msg)
    @fail = true
    @err_msg = err_msg
    logger.info "\n\n#{@err_msg}\n\n"
  end
end
