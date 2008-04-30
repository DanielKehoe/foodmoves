module Roar
  # simple class to allow descending into a hash 
  # to enable rails helper methods.
  class FilterData < HashWithIndifferentAccess
    def method_missing(symbol, *args)
      if symbol.to_s[-1..-1] == "=" then
        self[symbol.to_s[0..-2]] = args[0]
      else
        self[symbol.to_s]
      end
    end
  end
end