class FoodsController < ApplicationController
    layout "admin"

    # from acl_system2 example
    before_filter :login_required
    access_control :DEFAULT => '(admin | manager)',
                    :destroy => 'admin'

    # for hierachical pick list
    live_tree :food_tree, :model => :food
    auto_complete_for :food, :name
    
    def show_tree
      @root = Food.find(1)
    end

    def specify_food
      @parent = Food.find(params[:id])
      @food = Food.new
      @food.parent_id = @parent.id
      render(:update) do |page|
        page[:parent].replace :partial => 'parent', :object => @food
      end
    end
                      
    # GET /foods
    # GET /foods.xml
    def index
      if !params[:food].nil?
        unless params[:food][:name].nil?
          @foods = Food.paginate :per_page => 20, 
                                        :page => params[:page],
                                        :conditions => ['name like ?', "%#{params[:food][:name]}%"],
                                        :order => 'updated_at DESC, id ASC'
        end
        unless params[:food][:plu].nil?
          @foods = Food.paginate :per_page => 20, 
                                        :page => params[:page],
                                        :conditions => ['plu = ?', params[:food][:plu]],  
                                        :order => 'updated_at DESC, id ASC'
        end 
        unless params[:food][:en_espanol].nil?
          logger.info "\n\n #{params[:food][:en_espanol]}  \n\n"
          @foods = Food.paginate :per_page => 20, 
                                        :page => params[:page],
                                        :conditions => ['en_espanol like ?', "%#{params[:food][:en_espanol]}%"],  
                                        :order => 'updated_at DESC, id ASC'
          logger.info "\n\n @foods.size #{@foods.size}  \n\n"
       end                              
      elsif !params[:sort].nil?
        case params[:sort]
        when "Spanish Name"
          @foods = Food.paginate :per_page => 20, 
                                        :page => params[:page],
                                        :conditions => ["en_espanol != '' OR en_espanol IS NOT NULL"],
                                        :order => 'en_espanol ASC'
        when "name"
          @foods = Food.paginate :per_page => 20, 
                                        :page => params[:page],
                                        :order => 'name ASC'
        when "PLU"
          @foods = Food.paginate :per_page => 20, 
                                        :page => params[:page],
                                        :conditions => ["plu != ''"],
                                        :order => 'plu ASC'
        when "Missing PLU"
          @foods = Food.paginate :per_page => 20, 
                                        :page => params[:page],
                                        :conditions => ["plu = '' OR plu IS NULL"],
                                        :order => 'name ASC'
        when "No Spanish Name"
          @foods = Food.paginate :per_page => 20, 
                                        :page => params[:page],
                                        :conditions => ["en_espanol = '' OR en_espanol IS NULL"],
                                        :order => 'name ASC'
        when "ID"
          @foods = Food.paginate :per_page => 20, 
                                        :page => params[:page],  
                                        :order => 'id ASC'
        when "Reverse ID"
          @foods = Food.paginate :per_page => 20, 
                                        :page => params[:page],  
                                        :order => 'id DESC'
        when "Parent ID"
          @foods = Food.paginate :per_page => 20, 
                                        :page => params[:page],  
                                        :order => 'parent_id ASC'   
        end                             
      else
        @foods = Food.paginate :per_page => 20, 
                                      :page => params[:page],
                                      :order => 'updated_at DESC, id ASC'
      end
      respond_to do |format|
        format.html # index.rhtml
        format.xml  { render :xml => @foods.to_xml }
        format.csv {
          @foods = Food.find :all, :order => 'updated_at DESC'
          render :text => @foods.to_csv 
          response.headers['Content-Type'] = 'text/csv; charset=utf-8; header=present'
          response.headers['Content-Disposition'] = "attachment; filename=foods_#{Time.now.strftime("%d-%m-%Y-%H-%M-%S")}.csv"
        }
      end
    end

    # GET /foods/1
    # GET /foods/1.xml
    def show
      @food = Food.find(params[:id]) or raise ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html # show.rhtml
        format.xml  { render :xml => @food.to_xml }
      end
    end

    # GET /foods/new
    def new
      @food = Food.new
      @colors = Color.find(:all, :order => "sort_order, name")
      @growns = Grown.find(:all, :order => "sort_order, name")
      @packs = Pack.find(:all, :order => "sort_order, name")
      @per_cases = PerCase.find(:all, :order => "sort_order, name")
      @sizes = Size.find(:all, :order => "sort_order, name")
      @weights = Weight.find(:all, :order => "sort_order, name")
    end

    # GET /foods/1;edit
    def edit
      @food = Food.find(params[:id]) or raise ActiveRecord::RecordNotFound
      @colors = Color.find(:all, :order => "sort_order, name")
      @growns = Grown.find(:all, :order => "sort_order, name")
      @packs = Pack.find(:all, :order => "sort_order, name")
      @per_cases = PerCase.find(:all, :order => "sort_order, name")
      @sizes = Size.find(:all, :order => "sort_order, name")
      @weights = Weight.find(:all, :order => "sort_order, name")
    end

    # POST /foods
    # POST /foods.xml
    def create
      @food = Food.new(params[:food])
      @colors = Color.find(:all, :order => "sort_order, name")
      @growns = Grown.find(:all, :order => "sort_order, name")
      @packs = Pack.find(:all, :order => "sort_order, name")
      @per_cases = PerCase.find(:all, :order => "sort_order, name")
      @sizes = Size.find(:all, :order => "sort_order, name")
      @weights = Weight.find(:all, :order => "sort_order, name")
      @food.updated_by = @current_user.email 
      respond_to do |format|
        if @food.save
          flash[:notice] = 'Food was successfully created.'
          format.html { redirect_to food_url(@food) }
          format.xml  { head :created, :location => food_url(@food) }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @food.errors.to_xml }
        end
      end
    end

    # PUT /foods/1
    # PUT /foods/1.xml
    def update
      # if no checkboxes were checked, set the options to nil
      params[:food][:color_ids] ||= []
      params[:food][:grown_ids] ||= []
      params[:food][:pack_ids] ||= []
      params[:food][:per_case_ids] ||= []
      params[:food][:size_ids] ||= []
      params[:food][:weight_ids] ||= []
      # set the attributes from the submitted form
      @food = Food.find(params[:id])
      if params[:food][:parent_id] == params[:id]
        flash[:notice] = "Can't set the parent to be the same as this product!"
        redirect_to food_url(@food)
      else
        respond_to do |format|
          params[:food][:updated_by] = @current_user.email
          if @food.update_attributes(params[:food])
            flash[:notice] = 'Food was successfully updated.'
            format.html { redirect_to food_url(@food) }
            format.xml  { head :ok }
          else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @food.errors.to_xml }
          end
        end
      end
    end

    # DELETE /foods/1
    # DELETE /foods/1.xml
    def destroy
      @food = Food.find(params[:id])
      name = @food.name.nil? ? 'Item' : @food.name
      @food.destroy
      respond_to do |format|
        flash[:notice] = "#{name} was successfully deleted."
        format.html { redirect_to foods_url }
        format.xml  { head :ok }
      end
    end

    protected

    def permission_denied
      flash[:notice] = "You don't have privileges to access that area."
      return redirect_to :action => 'denied'
    end

  end
