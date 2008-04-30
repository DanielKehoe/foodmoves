class ContactsController < ApplicationController

  layout "admin"
    
  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager | support)'
  
  # for search function
  auto_complete_for :contact, :last_name

  # Standard RESTful methods

  # GET /contacts
  # GET /contacts.xml
  def index
    unless params[:contact].nil?
      @contacts = Contact.paginate :per_page => 20, 
                                  :page => params[:page],
                                  :conditions => ['last_name like ?', "%#{params[:contact][:last_name]}%"], 
                                  :order => 'updated_at DESC'
    else
      @contacts = Contact.paginate :per_page => 20, 
                                  :page => params[:page],
                                  :order => 'updated_at DESC'
    end
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @contacts.to_xml }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @contact.to_xml }
    end
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    @contact.region_id = 9
    @contact.country_id = 239
  end

  # GET /contacts/1;edit
  def edit
    @contact = Contact.find(params[:id])
  end

  # POST /contacts
  # POST /contacts.xml
  def create
    @contact = Contact.new(params[:contact])
    @contact.created_by = @current_user.name
    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Contact was successfully created.'
        format.html { redirect_to contact_url(@contact) }
        format.xml  { head :created, :location => contact_url(@contact) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors.to_xml }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to contact_url(@contact) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors.to_xml }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.xml  { head :ok }
    end
  end
end
