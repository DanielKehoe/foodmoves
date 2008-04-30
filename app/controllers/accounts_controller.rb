class AccountsController < ApplicationController

  layout "admin"
    
  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager | support | sales)'
  
  # for search function
  auto_complete_for :account, :name

  # Standard RESTful methods

  # GET /accounts
  # GET /accounts.xml
  def index
    unless params[:account].nil?
      @accounts = Account.paginate :per_page => 20, 
                                  :page => params[:page],
                                  :conditions => ['name like ?', "%#{params[:account][:name]}%"], 
                                  :order => 'updated_at DESC'
    else
      @accounts = Account.paginate :per_page => 20, 
                                    :page => params[:page],
                                    :order => 'updated_at DESC'
    end
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @accounts.to_xml }
      format.csv {
        @accounts = Account.find :all, :order => 'updated_at DESC'
        render :text => @accounts.to_csv 
        response.headers['Content-Type'] = 'text/csv; charset=utf-8; header=present'
        response.headers['Content-Disposition'] = "attachment; filename=auctions_#{Time.now.strftime("%d-%m-%Y-%H-%M-%S")}.csv"
      }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @account.to_xml }
    end
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1;edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = Account.new(params[:account])

    respond_to do |format|
      if @account.save
        flash[:notice] = 'Account was successfully created.'
        format.html { redirect_to account_url(@account) }
        format.xml  { head :created, :location => account_url(@account) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors.to_xml }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = 'Account was successfully updated.'
        format.html { redirect_to account_url(@account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors.to_xml }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_url }
      format.xml  { head :ok }
    end
  end
end
