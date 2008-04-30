require 'roar/rails/controller'

module Roar::Rails
  module ActMethods
    # 
    # Tell the controller to act as a roar controller.  
    # 
    # Pass in a block to define how the collection (Roar::Collection) and forms (Roar::Form) look.
    #
    # Configuration options are:
    #
    # * +subdomain+ - The injected actions will only apply if the subdomain matches. This is useful for separating the admin functionality from the public site, for example.
    #
    # * +layout+ - The layout to apply for the admin actions.  Default is the "roar" layout.
    # 
    # * +view+ - View defines the path (from the roar template path) to search for templates, in order to provide different views.  Default is 'default'.
    #
    # * +parent+ - For nested routes, uses the parent_id param for the routes.
    #
    # Example: <tt>roar :subdomain=>"admin", :layout=>"custom" do ... </tt>
    #
    def roar(options={}, &block)
      key = options[:subdomain] || options[:prefix] || ""
      
      do_include = self.roar_options.empty? ? true : false
      
      self.roar_options[key] =  Roar::Settings.roar_options.merge(options)
      self.roar_options[key][:parent] = [self.roar_options[key][:parent]].flatten
      self.roar_options[key][:roar_definition] = block

      # Only include once
      if do_include
        
        cattr_accessor :model_name, :model_class, :model_symbol, :collection_symbol
      
        include Roar::Rails::Controller
      
        helper_method :model_name, :model_class, :model_symbol, :collection_symbol
        helper_method :collection_path, :collection_path_for, :edit_path, :model_path, :new_path, :member_path
        helper_method :has_parent?, :roar
      
        before_filter :roar_custom_filters
        before_filter :load_parent
        before_filter :load_instance, :only=>[:show,:edit,:update,:destroy,:delete]
        before_filter :load_collection, :only=>[:index]
      
        before_filter :process_subdomain
      end
      
      roar_alias_resource_methods_to(key)
  
    end
    
    def roar_alias_resource_methods_to(key)
      [:index,:show,:new,:create,:edit,:update,:delete,:destroy].each do |action|
        send(:alias_method, (key.blank? ? action : "#{key}_#{action}"), "roar_#{action}") 
      end
    end

    # Define an action that can be used with roar.  This acts the same was as definining 
    # a normal action would, except it handles rewriting the method name, so that it works
    # if a subdomain is used for scoping roar.
    #
    # Example:
    # 
    #   roar_action(:auto_complete) do
    #     # auto complete action here
    #   end
    # 
    def roar_action(action_name, options={}, &block)
      key = options[:subdomain] || options[:prefix] || ""
      name = key.blank? ? "#{action_name}" : "#{key}_#{action_name}"
      define_method(name, &block)      
    end
    
    # Defines an action that works with the roar widgets to provide auto complete for
    # a resource.
    # 
    # Required parameter:
    #
    # * +fields+ - A symbol, or list of symbols representing the fields to search.
    # 
    # Configuration options are:
    # 
    # * +limit+ - The number of resources to return, default is <tt>10</tt>
    # 
    # * +order+ - Order of the returned resources.  
    # 
    # Example: 
    #
    # <tt>roar_auto_complete [:login, :firstname, :lastname], :limit => 20, :order => "cretaed_at"</tt>
    #
    def roar_auto_complete(fields, options={})
      options = {:limit=>10, :order=>nil}.merge(options)
      roar_action("auto_complete", options) do
        q = model_class.query
        s = "%#{params[model_symbol]}%"
        [fields].flatten.inject(q.or) { |query,field| query << q.like(field, s) }
        @records = q.find(:limit=>options[:limit], :order=>options[:order])
        render :roar_partial => "auto_complete"
      end
    end
    
    # Defines an action that works with the sortable list view to sort resources defined with
    # acts_as_list.  
    # Currently pretty naive, doesn't work with scoped lists.
    def roar_order(options={})
      roar_action("order", options) do
        model_class.find(:all, :order=>"position").each do |record|
          new_position = params["sortable"].index(record.id.to_s)+1
          record.update_attribute(:position, new_position) if record.position != new_position
        end
        render :nothing => true
      end
    end
  end
end  
