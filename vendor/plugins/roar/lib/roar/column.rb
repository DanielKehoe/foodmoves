module Roar
  # 
  # Represents a table column
  #
  class Column
    attr_accessor :options, :name, :type, :method, :block, :view
    
    def initialize(type, method=nil, options = {}, &b)
      self.type = type
      self.method = method
      self.options = options 
      self.view = options[:view] || "default"
      self.name = options.delete(:name) || (method.nil? ? type.to_s.humanize : method.to_s.gsub('.',' ').humanize)
      self.block = block_given? ? b : nil
    end

    #
    # Return the column attribute plus if a block has been given to the column, evaluate the block.  
    def data(record, viewcontext)
      if block.nil? then
        attribute(record)
      else
        if block.arity > 0 then
          block.call(attribute(record))
        else
          viewcontext.instance_variable_set(:@record, record)
          viewcontext.instance_variable_set(:@column_attribute, attribute(record))
          viewcontext.instance_eval(&block) #.call(data)
        end
      end
    end    

    # Retrieve the column data.  If method is a symbol, retrieve the attribute from the passed in record, otherwise
    # return method.    
    def attribute(record)
      method.is_a?(Symbol) ? self.method.to_s.split(".").inject(record) { |r,m| r.send(m) } : method
    end
  end
end