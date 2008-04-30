module Criteria  
  
  class Expression
    attr_accessor :table_alias
    def conditions
      nil
    end
    
    def parameters
      nil
    end
    
    def prefix
      @table_alias.alias
    end
  end
  
  class CompoundExpression < Expression
    include Filterable
    
    def add(expression, &block)
      if expression.is_a? TableAlias
        expr = expression.expressions.pop
        super expr
        expr.table_alias = expression
      else
        res = super expression
        yield expression if block_given?
        res
      end
    end
    
    def << expression
      add(expression)
      self
    end
    
  end
  
  class NameExpression < Expression
    def initialize(name)
      @name = name
    end
  end
  
  class NameValueExpression < NameExpression
    def initialize(name, value)
      @name = name
      @value = value
    end
    
    def parameters
      @value
    end
  end
  
  class OperatorExpression < NameValueExpression
    def conditions
      " ( #{prefix}.#{@name} #{operator} ? ) "
    end
    
  end
  
  def Criteria.operator_expression name, operator
    module_eval <<-END
    class #{name.to_s.capitalize}Expression < OperatorExpression
      def operator 
        '#{operator}'
      end
    end    
    END
  end
  
  operator_expression :eq, '='
  operator_expression :ne, '<>'
  operator_expression :lt, '<'
  operator_expression :lte, '<='
  operator_expression :gt, '>'
  operator_expression :gte, '>='
  operator_expression :like, 'LIKE'
  
  class InExpression < NameValueExpression
    def conditions
      " ( #{prefix}.#{@name} IN (?) ) "
    end
    def parameters
      super
    end
  end
  
  class NotExpression < CompoundExpression
    def conditions
      return nil unless @expressions and not @expressions.empty?
      " ( NOT #{super} ) "
    end
  end
  
  class IsNotNullExpression < NameExpression
    def conditions
      " ( #{prefix}.#{@name} IS NOT NULL ) "
    end
  end

  class IsNullExpression < NameExpression
    def conditions
      " ( #{prefix}.#{@name} IS NULL ) "
    end
  end
  
  class Disjunction < CompoundExpression    
    def conditions
      return nil unless @expressions and not @expressions.empty?
      " ( #{@expressions.collect { |expr| expr.conditions }.join(' OR ')} ) "
    end
  end

  class Conjunction < CompoundExpression
    def conditions
      return nil unless @expressions and not @expressions.empty?
      " ( #{@expressions.collect { |expr| expr.conditions }.join(' AND ')} ) "
    end
  end
  
  # add shortcut methods to Filterable
  module Filterable
    def Filterable.expression name, klass=nil
      class_name = if klass
        klass.name
      else
        "#{name.to_s.capitalize}Expression"
      end
      module_eval <<-END
        def #{name.to_s} name, value
          add #{class_name}.new(name, value)
        end
      END
    end
    
    expression :eq
    expression :ne
    expression :gt
    expression :gte
    expression :lt
    expression :lte
    expression :like
    expression :in
    
    alias :before :lt
    alias :after :gt
    
    
    def not &block
      add NotExpression.new, &block
    end
    
    def disjunction &block
      add Disjunction.new, &block
    end
    alias or disjunction
    
    def conjunction &block
      add Conjunction.new, &block
    end
    alias and conjunction
    
    def is_not_null name
      add IsNotNullExpression.new(name)
    end
    
    def is_null name
      add IsNullExpression.new(name)
    end
  end

end