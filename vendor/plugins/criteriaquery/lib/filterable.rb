module Criteria
  
  # mixin for classes that can contain expressions
  module Filterable
    attr_reader :expressions

    # Adds an expression to the current Filterable.
    # Propagates the Filterable's TableAlias to the newly added expression.
    def add(expression, &block)
      (@expressions ||= []) << expression
      expression.table_alias = table_alias unless expression.is_a? TableAlias
      yield expression if block_given?
      return self unless expression.class.include? Filterable
      expression
    end
    
    alias << add
    
    # delegates to the find() method of the parent query
    def find options={}
      query.find options
    end
    
    # dynamically builds aliases for adding criteria.
    # If a program calls some_name_<operation>, send(:operation, 'some_name', args) will be executed
    def method_missing name, *args
      name = name.to_s
      # check for magic join
      if table_alias.model_class.reflect_on_association(name.intern)
        return join(name.intern)
      end
      case name
        when /(.*)_is_null/
          return expression_for(:is_null, $1)
        when /(.*)_is_not_null/
          return expression_for(:is_not_null, $1)
        when /(.*)_not_(.*)/
          return expression_for(:not).expression_for($2, $1.intern, *args)
          return self
        when /(.*)_(.*)/
          return expression_for($2, $1.intern, *args)
        else
          super
      end
    end
    
    # creates a new expression. If the field name the expression is created for is not valid for the current #TableAlias, an exception is raised.
    def expression_for( expression_name, attribute=nil, *args)
      # check if an attribute of this name exists
      raise "#{attribute.to_s} is not a column on model class #{table_alias.model_class.name}" unless attribute and table_alias.model_class.columns_hash[attribute.to_s]
      send expression_name, attribute, *args
    end

    # builds the condition (where clause) for this query
    def conditions
      return nil unless @expressions
      con = @expressions.inject([]) do |cond,expr| 
          cond << expr.conditions if expr.conditions and not expr.conditions.empty?
          cond
        end
      return " (  #{con.compact.join(' AND ')}  ) " if con and not con.empty?
      nil
    end
    
    # builds he positional parameter array for this query
    def parameters
      return nil unless @expressions
      @expressions.inject([]) do |params,expr|
        return params unless expr.parameters
        if expr.class.include? Filterable
          params += expr.parameters
        else
          params << expr.parameters
        end
      end.compact
    end
    
  end
end