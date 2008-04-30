require 'roar/filter'
require 'roar/filter_data'

module Roar
  # 
  # FilterSet is the list of filters defined for Roar.  Roar::FilterSet.register is
  # provided to allow custom filters to be defined.
  # 
  class FilterSet
    include Enumerable
    
    class_inheritable_accessor  :definition
    cattr_accessor :filters
    attr_accessor :filters, :view, :params, :query
    
    
    # Define a custom filter
    # The block should accept three params:
    # * +filterset+ - the filterset
    # * +name+ - name of the filter, or method name
    # * +options+ - an options hash
    def self.register(symbol, &block)
      @@filters ||= {}
      @@filters[symbol] = block
    end
    
    def custom
      yield query,params
    end
    
    def each
      @filters.each { |filter| yield filter }
    end
    
    def initialize(controller, view='default', &block)
      @view = view
      @params = Roar::FilterData.new
      @params.merge!(controller.params)
      #@params.merge!(controller.params[:filter] || {})
      @filters = []
      @query = ::Criteria::Query.new(controller.model_class)
      self.instance_eval(&self.definition) unless self.definition.nil?
      self.instance_eval(&block) if block_given?
    end
    
    def has_values?
      @params['filter'] && !@params['filter'].empty?
    end        

    def method_missing(symbol, name, options={}, &block)
      @@filters ||= {}
      raise "Unknown filter #{symbol}" unless @@filters.has_key?(symbol)
      @filters << Roar::Filter.new(symbol, name, options)
      @@filters[symbol].call(self,name,options)
    end 
  end
end

Roar::FilterSet.register(:search)  { |filterset,name,options|
  [options[:fields]].flatten.inject(filterset.query.or) {|query,field| 
    query.like(field, "%#{filterset.params[name]}%")
  } unless filterset.params[name.to_s].blank?
}

Roar::FilterSet.register(:recent_dates) { |filterset,name,options|
  case filterset.params[name]
    when "today" then filterset.query.gt(name, Time.today)
    when "week" then filterset.query.gt(name, Time.today-7.days)
    when "month" then filterset.query.gt(name, Time.today-1.month)
    when "year" then filterset.query.gt(name, Time.today-1.year)
  end
}

Roar::FilterSet.register(:select_field) {|filterset, name, options|
  filterset.query.eq(name, filterset.params[name]) unless filterset.params[name.to_s].blank?
}

Roar::FilterSet.register(:scoped_select_field) {|filterset, name, options|
  filterset.query.eq(name, filterset.params[name]) unless filterset.params[name.to_s].blank?
}