class TagForPhonesController < ApplicationController

  layout "admin"
  
  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager)'
  
  # Standard RESTful methods
  
  # GET /tag_for_phones
  # GET /tag_for_phones.xml
  def index
    @tag_for_phones = TagForPhone.find(:all, :order => "sort_order, name")

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @tag_for_phones.to_xml }
    end
  end

  # GET /tag_for_phones/1
  # GET /tag_for_phones/1.xml
  def show
    @tag_for_phone = TagForPhone.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @tag_for_phone.to_xml }
    end
  end

  # GET /tag_for_phones/new
  def new
    @tag_for_phone = TagForPhone.new
  end

  # GET /tag_for_phones/1;edit
  def edit
    @tag_for_phone = TagForPhone.find(params[:id])
  end

  # POST /tag_for_phones
  # POST /tag_for_phones.xml
  def create
    @tag_for_phone = TagForPhone.new(params[:tag_for_phone])

    respond_to do |format|
      if @tag_for_phone.save
        flash[:notice] = "Successfully created #{@tag_for_phone.name}."
        format.html { redirect_to tag_for_phone_url(@tag_for_phone) }
        format.xml  { head :created, :location => tag_for_phone_url(@tag_for_phone) }
      else
        flash[:notice] = "Unable to create #{@tag_for_phone.name}."
        format.html { render :action => "new" }
        format.xml  { render :xml => @tag_for_phone.errors.to_xml }
      end
    end
  end

  # PUT /tag_for_phones/1
  # PUT /tag_for_phones/1.xml
  def update
    @tag_for_phone = TagForPhone.find(params[:id])

    respond_to do |format|
      if @tag_for_phone.update_attributes(params[:tag_for_phone])
        flash[:notice] = "Successfully updated #{@tag_for_phone.name}."
        format.html { redirect_to tag_for_phone_url(@tag_for_phone) }
        format.xml  { head :ok }
      else
        flash[:notice] = "Unable to update #{@tag_for_phone.name}."
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tag_for_phone.errors.to_xml }
      end
    end
  end

  # DELETE /tag_for_phones/1
  # DELETE /tag_for_phones/1.xml
  def destroy
    @tag_for_phone = TagForPhone.find(params[:id])
    @tag_for_phone.destroy

    respond_to do |format|
      format.html { redirect_to tag_for_phones_url }
      format.xml  { head :ok }
    end
  end
end
