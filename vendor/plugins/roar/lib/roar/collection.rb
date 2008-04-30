require 'paginator'

module Roar
  #
  # Collection is the representation of the data view.
  # 
  # Options:
  # 
  # * +view+ - From the roar template_path, the view is the subdirectory that will be searched for the template.  The order for searching is:
  #   1. app/views/resource  (app/views/resource/subdomain if subdomain has been specified)
  #   2. app/views/roar/[view]
  #   3. app/views/roar/default - note, view == default in the simple case
  #   4. plugin_root/views/[view]
  #   5. plugin_root/views/default
  #                 
  # * +name+ - If multiple collections are defined, you can give them a name.  A name is required if the definitions use the same view.  If no name is defined, the view is used for the name.
  # * +include+ - same as defined at the roar level, but can be customized on a per collection basis
  # * +per_page+ - same as defined at the roar level, but can be customized on a per collection basis
  # * +order+ - same as defined at the roar level, but can be customized on a per collection basis
  # 
  # Example:
  #
  #      collection(:view => "list", :order => 20) do
  #        edit :name
  #        column :name
  #      end
  # 
  class Collection
    class_inheritable_accessor  :definition
    attr_accessor :options, :columns, :title, :view, :name
    attr_reader :pages, :pager, :page
    
    def initialize(base, options={}, &block)
      @options = base.collection_options.merge(options)
      self.view = @options[:view]
      self.name = @options[:name] || @options[:view]
      @options[:per_page] = 1000 if @options[:per_page]==0  # hack, how to select all?
      
      @base = base
      @controller = @base.controller
      @actions = Roar::Actions.new([]) # default actions are empty
            
      self.columns = []
      self.instance_eval(&block) if block_given?
    end
    
    
    def records
      go if @records.nil?
      @records
    end
    
    def pager
      go if @pager.nil?
      @pager
    end
        
    def method_missing(symbol, method=nil, *args, &block)
      options = args[0].is_a?(Hash) ? args[0] : {}
      @columns << Roar::Column.new(symbol, method, {:view=>self.view}.merge(options), &block)
    end 
    
    def params
      @filterset.params
    end
    
    def title
      @title || @controller.collection_symbol.to_s.titlecase
    end

    def has_actions?
      @actions.size > 0
    end
    
    def actions(actionlist=nil, &block)
      if !actionlist.nil? or block_given? then
        @actions = Roar::Actions.new(actionlist, &block)
      end
      @actions
    end
  private
    def go
      @base.parent.each {|parent|
        if @controller.params["#{parent}_id"] != "0" then
          @base.filters.query.eq("#{parent}_id", @controller.params["#{parent}_id"]) 
        end
      } if @base.has_parent?
      find_options = @base.has_filters? || @base.has_parent? ? @base.filters.query.find_options : {}
      # If custom conditions are provided, stomp all over any others that exist
      # TODO: They should be merged properly.
      find_options = {:conditions => options[:conditions]} unless options[:conditions].nil?
      find_options.merge!({:select => options[:select] }) unless options[:select].blank?
      #find_options.merge!({:joins => options[:joins] }) unless options[:joins].blank?
      #find_options.merge!({:group => options[:group] }) unless options[:group].blank?
      @pager = ::Paginator.new(@controller.model_class.count(find_options), options[:per_page]) do |offset, per_page|
        find_options.merge!({:limit => options[:per_page], :offset => offset})
        find_options.merge!({:order => options[:order] }) unless options[:order].blank?
        find_options.merge!({:include => options[:include] }) unless options[:include].blank?
        @controller.model_class.find(:all, find_options) 
      end
      @page = @pager.page(@controller.params[:page] || 1)
      @records = @page.items
    end
  
  end
end

