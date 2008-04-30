require 'dsl_accessor'
require 'roar/collection'
require 'roar/filter_set'

module Roar
  #
  # Roar::Base is the main entry point for Roar.  See Roar::Rails::ActMethods
  # for the documentation
  class Base
    dsl_accessor :per_page, :order, :include, :conditions, :select
    attr_accessor :view, :parent, :controller, :options, :layout
    attr_reader :collections, :before_filters
    attr_reader :edit_form_options, :edit_form_block, :new_form_options, :new_form_block
    
    def initialize(controller, options={}, &block)
      self.options = {:view=>"default", :parent=>[]}.merge(options)
      @controller = controller
      @view = self.options[:view]
      @parent = [self.options[:parent]].flatten
      @layout = {:layout => self.options[:layout]}
      @@filters ||= Proc.new {}
      @collections = []
      @collection_hash = {}
      @before_filters = []
      self.instance_eval(&block) if block_given?
    end
    
    def collection_options
      {:view => @view, :per_page => (@per_page || 10), :order => (@order || ""), 
        :include => (@include || ""), :conditions => (@conditions || nil), 
        :select => (@select || [])}
    end
    
    def key
      self.options[:subdomain] || self.options[:prefix] || ""
    end
    
    # Define a set of filters via a block
    # Example:
    #    
    def filters(&block)
      @filters ||= Roar::FilterSet.new(@controller, @view, &block)
    end
    
    # Define a single filter.
    # 
    # Example: <tt>filter :search, :fields => [:title,:body]</tt>
    #
    def filter(type, *args, &b)
      filters.send(type, *args, &b)
    end

    # Have any filters been defined?
    #
    def has_filters?
      @filters.nil? ? false : @filters.filters.size > 0
    end

    def has_parent?
      !@parent.empty?
    end
    
    # Define the collection
    def collection(options={}, &block)
      if block_given? || @collections.empty?
        collection = Roar::Collection.new(self, options, &block)
        @collections << collection
        @collection_hash[collection.name.to_sym] = collection
      else
        name = options[:name] || options[:view] || @controller.params[:view]
        name.nil? ? @collections.first : @collection_hash[name.to_sym]
      end
    end
    alias :table :collection
    alias :tables :collections
    
    # Define the form.  This form is defined for both edit and new actions.
    def form(options={}, &block)
      @edit_form_options = @new_form_options = {:view=>@view}.merge(options)
      @edit_form_block = @new_form_block = block
    end
    
    # Define custom before filters.
    def before_filter(*filters)
      @before_filters += filters
    end
            
    def new_form(options={}, &block)
      @new_form_options = {:view=>@view}.merge(options)
      @new_form_block = block
    end
    
    def edit_form(options={}, &block)
      @edit_form_options = {:view=>@view}.merge(options)
      @edit_form_block = block
    end
  end
end
