require 'table_alias'
require 'filterable'
require 'expressions'
require 'join'
module Criteria

  # Repesents a query object. Queries are created by calling the #query method on an Activerecord object:
  # <code>pq = Person.query</code>
  class Query < TableAlias
    # include TableAlias
    include Filterable
    
    def initialize( model_class )
      @model_class = model_class
      @query = self
      @table_alias = self
      @join_aliases = {model_class.table_name=>[model_class.table_name]}
      @alias = model_class.table_name
    end
    
    # constructs an options hash that can be passed to a ActiveRecord find method
    def find_options options={}
      con = conditions
      par = parameters
      inc = includes
      cond_ary = nil
      if conditions
        cond_ary=[con]
        cond_ary += par if par
      end
      options[:conditions] = cond_ary if cond_ary
      options[:include] = includes if includes
      options      
    end
    
    # execute the query. Pass in additional ActiveRecord find options, for example
    # <code>Person.query.find(:all, :limit=>20, :order=>'name')</code>
    # method can be :all or :first, if omitted will default to :all.
    def find method=:all, options={}
      if method.is_a? Hash
        options = method
        method= :all
      end
      model_class.find method, find_options(options)
    end
    
    def count options
      model_class.count method, find_options(options)      
    end
    
    # shortcut for find(:first)
    def find_one options
      find :first, options
    end
    
    # builds the correct join alias for association includes
    # the table name is determined by reflecting on the parent model classes' association attribute
    # if this is the first time this table is used in the query, user the table name as the alias
    # for subsequent uses, uses <pluralized_attribute_name>_<table_name>[_index] where index is only used if the same association is used more than once (see ActiveRecord::Associations::Base)
    def join_alias(join)
      table_name = join.model_class.table_name
      new_alias = table_name
      if @join_aliases[table_name]
        new_alias = "#{join.reflection.pluralize}_#{join.parent.model_class.table_name}"
        if @join_aliases[table_name].include? new_alias
          new_alias += '1'
          while @join_aliases[table_name].include? new_alias
            new_alias = new_alias.succ
          end
        end
      end
      (@join_aliases[table_name] ||= []) << new_alias
      return new_alias
    end
   
    # returns the hash to be used for the :include option passed to the ActiveRecord find method.
    def includes
      return nil unless @joins and not @joins.empty?
      includes = @joins.collect{|j| j.includes}
    end
    
  end

end