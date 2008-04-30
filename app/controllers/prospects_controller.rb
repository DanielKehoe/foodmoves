class ProspectsController < ApplicationController

  layout "admin"
    
  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager | support | sales)'
  
  # for search function
  auto_complete_for :prospect, :name

  def step_two_for_new
    @prospect = Prospect.new(params[:prospect])
    @phone = Phone.new
    @phone.region_id = @prospect.region_id
    @phone.country_code= Geographies::Country.find(@prospect.country_id).phone_code
    @phone_tags = TagForPhone.find(:all, :order => "sort_order, name")
    @mail_address = Address.new
    @mail_address.region_id = @prospect.region_id
    @mail_address.country_id = @prospect.country_id
    @mail_address.admin_area_id = @prospect.admin_area_id
    @physical_address = Address.new
    @physical_address.region_id = @prospect.region_id
    @physical_address.country_id = @prospect.country_id
    @physical_address.admin_area_id = @prospect.admin_area_id
    # RENDER
    render :partial => 'form_two', :layout => false
  end

  def step_three_for_new
    @prospect = Prospect.new(params[:prospect])
    @phone = Phone.new(params[:phone])
    @phone_tags = TagForPhone.find(:all, :order => "sort_order, name")
    @mail_address = Address.new
    @mail_address.region_id = @prospect.region_id
    @mail_address.country_id = @prospect.country_id
    @mail_address.admin_area_id = @prospect.admin_area_id
    @mail_address.locality = @prospect.locality
    @physical_address = Address.new
    @physical_address.region_id = @prospect.region_id
    @physical_address.country_id = @prospect.country_id
    @physical_address.admin_area_id = @prospect.admin_area_id
    @physical_address.locality = @prospect.locality
    # RENDER
    render :partial => 'form_three', :layout => false
  end

  def step_four_for_new
    @prospect = Prospect.new(params[:prospect])
    @phone = Phone.new(params[:phone])
    @phone_tags = TagForPhone.find(:all, :order => "sort_order, name")
    @mail_address = Address.new(params[:mail_address])
    @physical_address = Address.new
    @physical_address.region_id = @mail_address.region_id
    @physical_address.country_id = @mail_address.country_id
    @physical_address.admin_area_id = @mail_address.admin_area_id
    @physical_address.locality = @mail_address.locality
    @physical_address.thoroughfare = @mail_address.thoroughfare
    @physical_address.postal_code = @mail_address.postal_code
    # RENDER
    render :partial => 'form_four', :layout => false
  end

  def step_five_for_new
    @prospect = Prospect.new(params[:prospect])
    @phone = Phone.new(params[:phone])
    @phone_tags = TagForPhone.find(:all, :order => "sort_order, name")
    @mail_address = Address.new(params[:mail_address])
    @physical_address = Address.new(params[:physical_address])
    @contact = Contact.new
    @contact.region_id = @prospect.region_id
    @contact.country_id = @prospect.country_id
    @contact.industry_role = @prospect.industry_role
    # RENDER
    render :partial => 'form_five', :layout => false
  end

  def step_six_for_new
    @prospect = Prospect.new(params[:prospect])
    @phone = Phone.new(params[:phone])
    @phone_tags = TagForPhone.find(:all, :order => "sort_order, name")
    @mail_address = Address.new(params[:mail_address])
    @physical_address = Address.new(params[:physical_address])
    @contact = Contact.new(params[:contact])
    # RENDER
    render :partial => 'form_six', :layout => false
  end

  def add_from_bluebook
    @bluebook_member = BluebookMember.find(params[:id])
    @prospect = Prospect.new    
    @prospect.name = @bluebook_member.name
    # @prospect.industry_role has no equivalent for bluebook_member
    @prospect.locality = @bluebook_member.city.titlecase
    @prospect.admin_area_id = @bluebook_member.admin_area_id
    @prospect.country_id = @bluebook_member.country_id
    @prospect.admin_area_abbr = @bluebook_member.admin_area_abbr
    @prospect.country_name = @bluebook_member.country.titlecase
    @prospect.region_id = @bluebook_member.region_id
    @prospect.email = @bluebook_member.email
    @prospect.website = @bluebook_member.website
    unless @bluebook_member.website.blank?
      @prospect.source = 'web'
    else
      @prospect.source = 'bluebook'
    end
    @prospect.bluebook_member_id = @bluebook_member.bluebook_id
    @prospect.created_by = @current_user.id
    @prospect.created_by_name = @current_user.name 
    if @prospect.save
      unless @bluebook_member.voice_phone.nil?   
        @phone = Phone.new(
                        :phonable_id => @prospect.id,
                        :phonable_type => 'Prospect',
                        :tag_for_phone => 'company',
                        :local_number => @bluebook_member.phone_local_number,
                        :locality_code => @bluebook_member.phone_area_code,
                        :country_code => @bluebook_member.phone_country_code,
                        :region_id => @bluebook_member.region_id)
        @phone.save
      end
      unless @bluebook_member.mail_city.blank? 
        @org_mailing_address = Address.new(
                        :addressable_id => @prospect.id,
                        :addressable_type => 'Prospect',
                        :tag_for_address => 'mailing address',
                        :thoroughfare => @bluebook_member.thoroughfare_mailing,
                        :locality => @bluebook_member.mail_city,
                        :postal_code => @bluebook_member.mail_postal_code,
                        :admin_area_id => @bluebook_member.admin_area_id_mailing,
                        :country_id => @bluebook_member.country_id_mailing,
                        :region_id => @bluebook_member.region_id_mailing)
        @org_mailing_address.save
      end
      unless @bluebook_member.phys_city.blank?                     
        @org_physical_address = Address.new(
                        :addressable_id => @prospect.id,
                        :addressable_type => 'Prospect',
                        :tag_for_address => 'office location',
                        :thoroughfare => @bluebook_member.thoroughfare_physical,
                        :locality => @bluebook_member.phys_city,
                        :postal_code => @bluebook_member.phys_postal_code,
                        :admin_area_id => @bluebook_member.admin_area_id_physical,
                        :country_id => @bluebook_member.country_id_physical,
                        :region_id => @bluebook_member.region_id_physical)
        @org_physical_address.save
      end
      flash[:notice] = "Saved &quot;#{@bluebook_member.name}&quot; as a new prospect."
      render :action => :show
    else
      flash[:notice] = "Couldn't save &quot;#{@bluebook_member.name}&quot; as a prospect."
      redirect_to bluebook_member_url(@bluebook_member)
    end
  end
             
  # Standard RESTful methods
  
  # GET /prospects
  # GET /prospects.xml
  def index
    unless params[:prospect].nil?
      @prospects = Prospect.paginate :per_page => 20, 
                                  :page => params[:page],
                                  :conditions => ['name like ?', "%#{params[:prospect][:name]}%"], 
                                  :order => 'updated_at DESC'
    else
      @prospects = Prospect.paginate :per_page => 20, 
                                    :page => params[:page],
                                    :order => 'updated_at DESC'
    end 
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @prospects.to_xml }
      format.csv {
        @prospects = Prospect.find :all, :order => 'updated_at DESC'
        render :text => @prospects.to_csv 
        response.headers['Content-Type'] = 'text/csv; charset=utf-8; header=present'
        response.headers['Content-Disposition'] = "attachment; filename=auctions_#{Time.now.strftime("%d-%m-%Y-%H-%M-%S")}.csv"
      }
    end
  end

  # GET /prospects/1
  # GET /prospects/1.xml
  def show
    @prospect = Prospect.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @prospect.to_xml }
    end
  end

  # GET /prospects/new
  def new
    @prospect = Prospect.new
    @prospect.region_id = 9
    @prospect.country_id = 239
    @phone = Phone.new
    @phone.region_id = 9
    @phone.country_code = 1
    @phone_tags = TagForPhone.find(:all, :order => "sort_order, name")
    @mail_address = Address.new
    @mail_address.region_id = 9
    @mail_address.country_id = 239
    @physical_address = Address.new
    @physical_address.region_id = 9
    @physical_address.country_id = 239
    @contact = Contact.new
    @contact.region_id = 9
    @contact.country_id = 239
    @administrators = Administrator.find(:all, :order => "last_name")
    render :layout => 'admin_tabbed'
  end

  # GET /prospects/1;edit
  def edit
    @prospect = Prospect.find(params[:id])
    @phone = Phone.new
    @phone.region_id = 9
    @phone.country_code = 1
    @phone_tags = TagForPhone.find(:all, :order => "sort_order, name")
    @mail_address = Address.new
    @mail_address.region_id = 9
    @mail_address.country_id = 239
    @physical_address = Address.new
    @physical_address.region_id = 9
    @physical_address.country_id = 239
    @contact = Contact.new
    @contact.region_id = 9
    @contact.country_id = 239
    @administrators = Administrator.find(:all, :order => "last_name")
    render :layout => 'admin_tabbed'
  end

  # POST /prospects
  # POST /prospects.xml
  def create
    @prospect = Prospect.new(params[:prospect])
    @prospect.created_by = @current_user.id
    @prospect.created_by_name = @current_user.name
    @phone = Phone.new(params[:phone])
    unless @phone.local_number.blank?
      @phone.phonable_type = 'Prospect'
      @prospect.phones << @phone
    end
    @mail_address = Address.new(params[:mail_address])
    unless @mail_address.thoroughfare.blank?
      @mail_address.addressable_type = 'Prospect'
      @mail_address.tag_for_address = 'mailing address'
      @prospect.addresses << @mail_address
    end
    @physical_address = Address.new(params[:physical_address])
    unless @physical_address.thoroughfare.blank?
      @physical_address.addressable_type = 'Prospect'
      @physical_address.tag_for_address = 'company location'
      @prospect.addresses << @physical_address
    end
    @contact = Contact.new(params[:contact])
    unless @contact.last_name.blank?
      @contact.created_by = @current_user.name
      @prospect.contacts << @contact
    end 
    respond_to do |format|
      if @prospect.save
        flash[:notice] = 'Prospect was successfully created.'
        format.html { redirect_to prospect_url(@prospect) }
        format.xml  { head :created, :location => prospect_url(@prospect) }
      else
        @administrators = Administrator.find(:all, :order => "last_name")
        format.html { render :action => "new" }
        format.xml  { render :xml => @prospect.errors.to_xml }
      end
    end
  end

  # PUT /prospects/1
  # PUT /prospects/1.xml
  def update
    @prospect = Prospect.find(params[:id])
    @prospect.updated_by = @current_user.name
    @phone = Phone.new(params[:phone])
    unless @phone.local_number.blank?
      @phone.phonable_type = 'Prospect'
      @prospect.phones << @phone
    end
    @mail_address = Address.new(params[:mail_address])
    unless @mail_address.thoroughfare.blank?
      @mail_address.addressable_type = 'Prospect'
      @mail_address.tag_for_address = 'mailing address'
      @prospect.addresses << @mail_address
    end
    @physical_address = Address.new(params[:physical_address])
    unless @physical_address.thoroughfare.blank?
      @physical_address.addressable_type = 'Prospect'
      @physical_address.tag_for_address = 'company location'
      @prospect.addresses << @physical_address
    end
    @contact = Contact.new(params[:contact])
    unless @contact.last_name.blank?
      @contact.created_by = @current_user.name
      @prospect.contacts << @contact
    end 
    respond_to do |format|
      if @prospect.update_attributes(params[:prospect])
        flash[:notice] = 'Prospect was successfully updated.'
        format.html { redirect_to prospect_url(@prospect) }
        format.xml  { head :ok }
      else
        @administrators = Administrator.find(:all, :order => "last_name")
        format.html { render :layout => 'admin_tabbed', :action => "edit" }
        format.xml  { render :xml => @prospect.errors.to_xml }
      end
    end
  end

  # DELETE /prospects/1
  # DELETE /prospects/1.xml
  def destroy
    @prospect = Prospect.find(params[:id])
    @prospect.destroy

    respond_to do |format|
      format.html { redirect_to prospects_url }
      format.xml  { head :ok }
    end
  end
end
