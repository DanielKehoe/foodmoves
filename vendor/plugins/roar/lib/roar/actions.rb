module Roar
  # 
  # A list of actions used for Roar Forms and Tables
  #
  class Actions
    include Enumerable
    
#     cattr_accessor :actions

#     def self.register(symbol, klass)
#       @@actions ||= {}
#       @@actions[symbol] = klass
#     end

#     def method_missing(symbol, options={})
#       @@actions ||= {}
#       raise "Unknown action #{symbol}" unless @@actions.has_key?(symbol)
#       @actions << @@actions[symbol].new(symbol, options)
#     end 
        
    def initialize(actionlist=nil, &block)
      @actions = (actionlist || []).collect {|a| Roar::Action.new(a) }
      self.instance_eval(&block) if block_given?
      @action_hash = @actions.inject({}) { |h,a| h.merge({a.name => a}) }
    end
    
    def each
      @actions.each { |filter| yield filter }
    end
    
    def active(name)
      @action_hash[name].symbol
    end
    
    def has_delete?
      @actions.delete(:delete)
    end
    
    def has_destroy?
      @actions.delete(:destroy)
    end
    
    def delete(symbol)
      @actions.delete(symbol)
    end
    
    def size
      @actions.size
    end
    
    # def do(name, method)
    #   @action_hash[name].instance_methods(method)
    # end
        
    def method_missing(symbol, options={})
      @actions << Roar::Action.new(symbol, options)
    end 
  end
end

# module Roar
#   class Save < Roar::Action
#     def do_html
#     end
    
#     def do_js
#     end
#   end

#   class SaveAndContinueEditing < Roar::Action
#   end

#   class SaveAndAddAnother < Roar::Action
#   end  
# end
# Roar::Actions.register(:save, Roar::Save)
# Roar::Actions.register(:save_and_continue_editing, Roar::SaveAndContinueEditing)
# Roar::Actions.register(:save_and_add_another, Roar::SaveAndAddAnother)


