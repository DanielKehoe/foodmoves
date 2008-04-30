module Roar
  # 
  # A simple class used to identify custom actions in Roar Forms and Tables.
  #
  class Action
    attr_accessor :name, :symbol, :options
    def initialize(symbol, options={})
      self.name = {:name=>symbol.to_s.humanize}.merge(options)[:name]
      self.symbol = symbol
      self.options = options
    end
    
    def ==(symbol)
      self.symbol == symbol
    end
    
    def to_s
      self.name
    end
  end
end


