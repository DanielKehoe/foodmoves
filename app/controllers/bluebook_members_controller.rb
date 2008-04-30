class BluebookMembersController < ApplicationController

  layout "admin"
    
  # from acl_system2 example
  before_filter :login_required
  access_control [:search, :index, :show] => '(admin)'
  
  # for search function
  auto_complete_for :bluebook_member, :name
  
  # Standard RESTful methods
  
  # GET /bluebook_members
  # GET /bluebook_members.xml
  def index
    @address = Address.new
    if !params[:address].nil?
      unless params[:address][:country_id].nil?
        @address.country_id = params[:address][:country_id]
        country_name = Geographies::Country.find(@address.country_id).name
        @bluebook_members = BluebookMember.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ['country = ?', country_name], 
                                      :order => 'country, state, city, section, name'
      end
      unless params[:address][:admin_area_id].nil?
        @address.admin_area_id = params[:address][:admin_area_id]
        state_name = Geographies::AdminArea.find(@address.admin_area_id).name
        @bluebook_members = BluebookMember.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ['state = ?', state_name], 
                                      :order => 'state, city, section, name'
      end
    elsif !params[:locality].nil?
        @bluebook_members = BluebookMember.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :conditions => ['city like ?', "%#{params[:locality]}%"],  
                                      :order => 'city, section, name'
    elsif !params[:bluebook_member].nil?
      @bluebook_members = BluebookMember.paginate :per_page => 20, 
                                    :page => params[:page],
                                    :conditions => ['name like ?', "%#{params[:bluebook_member][:name]}%"], 
                                    :order => 'section, country, state, city, name'                             
    else
      @bluebook_members = BluebookMember.paginate :per_page => 20, 
                                    :page => params[:page],
                                    :order => 'section, country, state, city, name'
    end
    respond_to do |format|
      format.html # index.rhtml
    end
  end

  # GET /bluebook_members/1
  # GET /bluebook_members/1.xml
  def show
    begin
      @bluebook_member = BluebookMember.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @bluebook_member = BluebookMember.new
      flash[:notice] = "We're unable to find a record for that entry in our database."
    end
    respond_to do |format|
      format.html # show.rhtml
    end
  end

end
