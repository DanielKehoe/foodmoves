class PhonesController < ApplicationController
  
  layout "admin"
  
  # from acl_system2 example
  before_filter :login_required
  access_control [:index, :destroy] => '(admin | manager | support)'
  
  # Standard RESTful methods

  # GET /phones
  # GET /phones.xml
  def index   
    @phones = Phone.paginate :per_page => 20, 
                                  :page => params[:page],
                                  :conditions => ['number like ?', "%#{params[:search]}%"], 
                                  :order => 'updated_at DESC'
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @phones.to_xml }
      format.csv {
        @phones = Phone.find :all, :order => 'updated_at DESC'
        render :text => @phones.to_csv 
        response.headers['Content-Type'] = 'text/csv; charset=utf-8; header=present'
        response.headers['Content-Disposition'] = "attachment; filename=phones_#{Time.now.strftime("%d-%m-%Y-%H-%M-%S")}.csv"
      }
    end
  end

  # GET /phones/1
  # GET /phones/1.xml
  def show
    @phone = Phone.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @phone.to_xml }
    end
  end

  # GET /phones/new
  def new
    if params[:user_id]
      @phone = Phone.new(:phonable_type => 'User', :phonable_id => params[:user_id])
      @name = User.find(params[:user_id]).name
    else
      @phone = Phone.new(:phonable_type => 'Organization', :phonable_id => params[:organization_id])
      @name = Organization.find(params[:organization_id]).name
    end
    @phone_tags = TagForPhone.find(:all, :order => "sort_order, name")
  end

  # GET /phones/1;edit
  def edit
    @phone = Phone.find(params[:id])
    @phone_tags = TagForPhone.find(:all, :order => "sort_order, name")
  end

  # POST /phones
  # POST /phones.xml
  def create
    @phone = Phone.new(params[:phone])
    respond_to do |format|
      if @phone.save
        flash[:notice] = "Successfully added #{@phone.number}."
        if permit?('support') then
          if @phone.phonable.kind_of? User
            format.html { redirect_to user_url(@phone.phonable) }
          else
            format.html { redirect_to organization_url(@phone.phonable) }
          end 
        else
          format.html { redirect_to member_url(@current_user) }
        end     
        format.xml  { head :created, :location => phone_url(@phone) }
      else
        flash[:notice] = "Unable to add #{@phone.number}."
        format.html { render :action => "new" }
        format.xml  { render :xml => @phone.errors.to_xml }
      end
    end
  end

  # PUT /phones/1
  # PUT /phones/1.xml
  def update
    @phone = Phone.find(params[:id])
    respond_to do |format|
      if @phone.update_attributes(params[:phone])
        flash[:notice] = "#{@phone.number} was successfully updated."
        if @phone.phonable.kind_of? User
          format.html { redirect_to user_url(@phone.phonable) }
        else
          format.html { redirect_to organization_url(@phone.phonable) }
        end       
        format.xml  { head :created, :location => phone_url(@phone) }
        format.xml  { head :ok }
      else
        flash[:notice] = "Unable to update #{@phone.number}."
        format.html { render :action => "edit" }
        format.xml  { render :xml => @phone.errors.to_xml }
      end
    end
  end

  # DELETE /phones/1
  # DELETE /phones/1.xml
  def destroy
    @phone = Phone.find(params[:id])
    @phone.destroy

    respond_to do |format|
      format.html { redirect_to phones_url }
      format.xml  { head :ok }
    end
  end
end
