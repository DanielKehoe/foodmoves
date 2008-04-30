module Roar
  module CoreExt
    module Array
      def to_select(text_method=:name)
        self.collect { |x| [x.send(text_method),x.id] }
      end
    end
  end
end
