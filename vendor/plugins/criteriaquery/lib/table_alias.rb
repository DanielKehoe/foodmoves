module Criteria
  
  # Supeclass for classes that can contain joins (Query and Join) and are therefore associated with a database table.
  class TableAlias
    
    # the class of the ActiveRecord model represented by this TableAlias
    attr_reader :model_class
    
    # the root query to which this TableAlias belongs
    attr_reader :query
    
    # 
    attr_reader :alias

    attr_reader :joins
    
    def join(attribute, options={}, &block)
      
      attribute = attribute.to_s
      
      new_join = Join.new(attribute, self)
      (@joins ||= []) << new_join
      (@joins_hash ||= {})[attribute] = new_join
      
      join_alias = (options[:as] || attribute).intern

      # we cannot add a join if a method with that name already exists
      if respond_to? join_alias
        raise "Invalid join name. A method #{join_alias} already exists. Use :as when defining the join"
      end
      
      add new_join
      
      yield new_join if block_given?
      
      new_join
    end
    
    def method_missing name, *args
      return @joins_hash[name] if @joins_hash[name] 
      join name, *args
    end
    
    def table_alias
      self
    end
    
  end  
end

