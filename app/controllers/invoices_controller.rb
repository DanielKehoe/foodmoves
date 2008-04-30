class InvoicesController < ApplicationController

  layout "admin"

  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager | support)'

  def mailed_invoice
    @invoice = Invoice.find(params[:id])
    if @invoice.update_attribute(:date_billed, Time.now)
      flash[:notice] = "Successfully updated invoice for auction #{@invoice.id}."
    else
      flash[:notice] = "Unable to update invoice for auction #{@invoice.id}."     
    end
    redirect_to invoices_url
  end

  def invoice_paid
    @invoice = Invoice.find(params[:id])
    if @invoice.update_attribute(:date_paid, Time.now)
      flash[:notice] = "Successfully updated invoice for auction #{@invoice.id}."
    else
      flash[:notice] = "Unable to update invoice for auction #{@invoice.id}."     
    end
    redirect_to invoices_url
  end
  
  # Standard RESTful methods

  # GET /invoices
  # GET /invoices.xml
  def index
    @invoices_to_mail = Invoice.find_invoices_to_mail
    @invoices_for_cc = Invoice.find_invoices_for_cc
    @open_invoices = Invoice.find_open_invoices
    @paid_invoices = Invoice.find_paid_invoices
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @invoices.to_xml }
      format.csv {
        all = Invoice.find_all_invoices
        render :text => all.to_csv 
        response.headers['Content-Type'] = 'text/csv; charset=utf-8; header=present'
        response.headers['Content-Disposition'] = "attachment; filename=invoices_#{Time.now.strftime("%d-%m-%Y-%H-%M-%S")}.csv"
      }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.xml
  def show
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @invoice.to_xml }
    end
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1;edit
  def edit
    @invoice = Invoice.find(params[:id])
  end

  # POST /invoices
  # POST /invoices.xml
  def create
    @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        flash[:notice] = "Successfully created invoice."
        format.html { redirect_to invoice_url(@invoice) }
        format.xml  { head :created, :location => invoice_url(@invoice) }
      else
        flash[:notice] = "Unable to create invoice."
        format.html { render :action => "new" }
        format.xml  { render :xml => @invoice.errors.to_xml }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.xml
  def update
    @invoice = Invoice.find(params[:id])
    if @invoice.update_attributes(params[:invoice])
      flash[:notice] = "Successfully updated invoice for auction #{@invoice.id}."
      redirect_to invoice_url(@invoice)
    else
      flash[:notice] = "Unable to update invoice for auction #{@invoice.id}."
      render :action => "edit"
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.xml
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
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
