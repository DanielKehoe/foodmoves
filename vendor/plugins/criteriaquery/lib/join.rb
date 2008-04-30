require 'table_alias'
require 'filterable'
module Criteria
  
  class Join < TableAlias
    # include TableAlias
    include Filterable
  
    attr_reader :reflection
    attr_reader :parent
    
    attr_accessor :table_alias
  
    def initialize(attribute, parent)
      @reflection = attribute
      @query = parent.query
      @parent = parent
      association_reflection = parent.model_class.reflect_on_association(attribute.intern)

      # if this is a polymorphic has_one or has_many association, raise an error as AR cannot support that
      raise "Eager loading for the has_one or has_many side of a polymorphic association cannot be supported by ActiveRecord" if association_reflection.options.include? :polymorphic
      
      # if we cannot reflect on the attribute, raise an exception
      raise "#{attribute} is not a relationship on class #{parent.model_class}" unless association_reflection

      @model_class = association_reflection.klass
    
      # build the alias for this join - need to take into account all other joins that 
      # have been defined for the query because of the AR aliasing scheme
      @alias = @query.join_alias(self)
    end
    
    def includes
      return reflection.intern unless @joins and not @joins.empty?
      return {reflection.intern=>[@joins.collect {|j| j.includes}]}
    end
    
    def table_alias
      self
    end
  
  end
  
end