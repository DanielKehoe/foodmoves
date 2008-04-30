module Roar
  # 
  # Represents a form field.
  # 
  class Field
    attr_accessor :type, :method, :name, :options, :parent, :fields

    def initialize(parent, type, method=nil, options={}, &block)
      @fields = []
      self.parent = parent
      self.type = type
      self.method = method
      self.name = options.delete(:name) || method.to_s.humanize
      self.options = options
      self.instance_eval(&block) if block_given?
    end

    def view
      self.parent.view
    end
    
    def add_path_segment(segment)
      path
      @path += "[#{segment}]"
    end
    
    def path
      @path ||= parent.is_a?(Roar::Form) ? parent.record.class.to_s.underscore : parent.path
    end
    
    def field_data(record)
      record.send(method)
    end
    
    # Delegate actions back to the form
    def actions(actionlist=nil, &block)
      self.parent.actions(actionlist, &block)
    end

    def method_missing(symbol, *args, &block)
      @fields << Roar::Field.new(self, symbol, *args, &block)
    end    
  end
end