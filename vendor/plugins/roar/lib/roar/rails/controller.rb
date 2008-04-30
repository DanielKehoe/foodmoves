module Roar::Rails
  #
  # Controller mixin
  #
  # The Resource CRUD methods are defined with a roar_ prefix, and are aliased
  # to the appropriate method, depending whether the subdomain has been specified.
  #
  module Controller
    def self.included(base)
      base.model_name ||= base.roar_options[base.roar_options.keys.first][:model_name] || base.name.split('::')[-1].chomp("Controller").singularize
      base.model_class = Class.class_eval("::#{base.model_name}")
      base.model_symbol = base.model_name.underscore.to_sym
      base.collection_symbol = base.model_name.underscore.pluralize.to_sym
      base.model_name = base.model_name.titlecase
    end
    
    def roar_index
      respond_to do |format|
        format.html { render({:roar => 'index'}.merge(roar.layout))  }
        format.js { 
          if params[:content_only]  # modalbox doesn't play nice with rjs
           render :roar_partial => 'embedded' 
          else 
            render :roar_rjs => 'index'
          end
        }
        format.json { render :json => roar.table.records.to_json }
        format.xml  { render :xml => roar.table.records.to_xml }
      end 
    end

    def roar_show
      respond_to do |format|
        format.html { render({:roar => 'show'}.merge(roar.layout)) }
        format.js { render :roar_partial => 'show', :locals=>{:record=>@record} }
        format.xml { render :xml => @record.to_xml }
      end 
    end

    def roar_new
      session[:roar_return_to] = request.env["HTTP_REFERER"]
      @record ||= model_class.new
      respond_to do |format|
        format.html { render({:roar => 'new'}.merge(roar.layout)) }
        format.js { render :roar_partial => 'new' }
      end
    end

    def roar_edit
      session[:roar_return_to] = request.env["HTTP_REFERER"]
      respond_to do |format|
        format.html { render({:roar => 'edit'}.merge(roar.layout)) }
        format.js { render :roar_partial => 'edit' }
      end
    end

    def roar_create
      @record = build_and_save_model
      respond_to do |format|
        if !@record.new_record?
          format.html { 
            flash[:notice] = "#{model_name} was successfully created."
            redirect = if params['save_and_continue_editing'] then
              edit_path(@record)
            elsif params['save_and_add_another'] then
              new_path
            elsif roar.table.view.to_sym == :show then
              model_path(@record)
            elsif session[:roar_return_to] then
              session[:roar_return_to]
            else
              collection_path
            end
            redirect_to redirect and return
          }
          format.xml  { head :created, :location => collection_path(@record) }
          format.js { render :roar_rjs => "actions/create_#{params['submit'] || 'save'}" }
        else
          format.html { render({:roar => 'new'}.merge(roar.layout)) }
          format.js { render :roar_rjs => 'new' }
          format.xml  { render :xml => @record.errors.to_xml }
        end        
      end
    end


    def roar_update
      respond_to do |format|
        if @record.update_attributes(params[model_symbol])
          format.html { 
            flash[:notice] = "#{model_name} was successfully updated."
            redirect = if params['save_and_continue_editing'] then
              edit_path(@record)
            elsif params['save_and_add_another'] then
              new_path
            elsif roar.table.view.to_sym == :show then
              model_path(@record)
            elsif session[:roar_return_to] then
              session[:roar_return_to]
            else
              collection_path
            end
            redirect_to redirect and return
          }
          format.js { render :roar_rjs => "actions/update_#{params['submit'] || 'save'}" }
          format.xml  { head :ok }
        else
          format.html { render({:roar => 'edit'}.merge(roar.layout)) }
          format.js { render :roar_rjs=>'edit' }
          format.xml  { render :xml => @record.errors.to_xml }
        end

      end
    end


    def roar_delete
      respond_to do |format|
        format.html { render({:roar => 'delete'}.merge(roar.layout)) }
        format.js { render :roar_rjs => 'delete' }
      end
    end

    def roar_destroy
      if @record.destroy
        respond_to do |format|
          format.html { 
            flash[:notice] = "#{model_name} was successfully deleted."
            redirect_to collection_path and return
          }
          format.xml  { head :ok }
          format.js { render :roar_rjs => 'destroy' }
        end
      else
        # TODO -- what's behavior here?
      end
    end

    # Return the roar instance for this controller
    def roar
      if @roar_instance.nil?
        opts = roar_options[request.subdomains.first]
        opts ||= roar_options[roar_options.keys.sort.reverse.detect { |key| request.path.match(/^\/#{key}/) }]
        @roar_instance = Roar::Base.new(self, opts, &opts[:roar_definition]) unless opts.nil?
      end 
      @roar_instance
    end
    
    def collection_path(sym=nil, prefix=nil)
      options = roar_enabled? ? roar.parent.inject({}) { |h,p| h.merge!({"#{p}_id".to_sym => params["#{p}_id"]})} : {}
      options.merge!({:view => params[:view]}) if params[:view]
      path = sym.nil? ? "#{collection_symbol}_path" : "#{sym.to_s.pluralize}_path"
      path = "#{prefix}_#{path}" unless prefix.nil?
      path = "roar_#{path}" if roar_enabled? and !roar.options[:prefix].nil? 
      send(path, options)
    end
    
    
    # 
    # Return the path to the collection.  
    # Examples:
    # collection_path_for  : Returns the collection path for the current model
    # collection_path_for(:league)         : leagues_path
    # collection_path_for(:division, league) : divisions_path(:league_id => 2)
    # collection_path_for(:league, :prefix=>"formatted", :format=>"json") :  /leagues.json
    # collection_path_for(:league, :something=>true) : leagues_path(:something => true)
    #
    # Note: format and prefix options are incomatible -- either or
    # The way this is structured, format and prefix are invalid path options
    def collection_path_for(sym=nil, options={})
      path_options = roar.parent.inject({}) { 
        |h,p| h.merge!({"#{p}_id".to_sym => params["#{p}_id"]})
      }
      path_options.merge!({"#{model_symbol}_id" => options.delete(:record).id}) if options[:record]
      path_options.merge!({:view => params[:view]}) if params[:view]
      path = sym.nil? ? "#{collection_symbol}_path" : "#{sym.to_s.pluralize}_path"
      path = "#{options.delete(:prefix)}_#{path}" if options[:prefix]
      path = "roar_#{path}" unless roar.options[:prefix].nil?
      path = "formatted_#{path}" if options[:format]
      path_options.merge!(options)  # Merge remaining options
      send(path, path_options)
    end
    

    def edit_path(r)
      path = "edit_#{r.class.to_s.underscore}_path"
      path = "roar_#{path}"  if roar_enabled? and !roar.options[:prefix].nil?
      send(path, path_options(r))
    end

    def new_path(sym=nil)
      path = sym.nil? ? "new_#{model_symbol}_path" : "new_#{sym}_path"
      path = "roar_#{path}"  if roar_enabled? and !roar.options[:prefix].nil?
      send(path, path_options)
    end

    def member_path(r, prefix)
      path = "#{prefix}_#{r.class.to_s.underscore}_path"
      path = "roar_#{path}" if roar_enabled? and !roar.options[:prefix].nil?
      send(path, path_options(r))
    end

    def model_path(r)
      path = "#{r.class.to_s.underscore}_path"
      path = "roar_#{path}" if roar_enabled? and !roar.options[:prefix].nil?
      send(path, path_options(r))
    end

    def has_parent?
      roar.nil? ? false : !roar.parent.empty?
    end

    def roar_enabled?
      !roar.nil?
    end

  private
        
    def process_subdomain
      self.action_name = "#{roar.key}_#{action_name}" if roar_enabled? && !roar.key.empty?
    end

    def load_instance
      @record = set_instance(model_symbol, model_class.find(params[:id])) if roar_enabled?
    end

    def load_collection
      # Ensure the collection gets created
      roar.table.records if roar_enabled?
    end
    
    def load_parent
      roar.parent.each {|parent|
        if params["#{parent}_id"] != "0" then
          parent_class = Class.class_eval(Inflector.camelize(parent))
          set_instance(parent, parent_class.find(params["#{parent}_id"]))
        end
      } if roar_enabled?
    end
    
    def roar_custom_filters
      roar.before_filters.each do |filter|
        send filter
      end if roar_enabled?
    end

    def set_instance(name, value)
     self.instance_variable_set("@#{name}", value)
    end

    def build_and_save_model
      base = if has_parent? then
        instance_variable_get("@#{roar.parent.last}").send(collection_symbol) 
      else
         model_class
      end      
      set_instance(model_symbol, base.create(params[model_symbol]))
    end 

    def path_options(r=nil)
      options = r.nil? ? {} : {:id=>r} 
      roar.parent.each do |p| 
        options["#{p}_id".to_sym] = params["#{p}_id"]
      end if roar_enabled?
      options.merge!({:view => params[:view]}) if params[:view]
      return options
    end              
  end
end
