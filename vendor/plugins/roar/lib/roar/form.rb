require 'roar/actions'
require 'roar/action'
require 'roar/field'

module Roar       
  #
  # Form is the representation of the create/update view
  # 
  # The block is eval'd, with each line being a new field.
  #   
  class Form
    attr_accessor :fieldset, :view, :actions, :record
                         
    def initialize(record, options={}, &block)
      @record = record
      options = {:view => "default"}.merge(options)
      @view = options[:view]
      @actions = Roar::Actions.new([:save,:destroy]) # default actions

      @fieldset = Roar::Field.new(self, :fieldset, &block)
    end
    
    def path
      fieldset.path
    end
    
    def fields
      fieldset.fields
    end    
    
    def has_file_field?
      fields.collect {|field| field.fields.empty? ? field : field.fields }.flatten.any? { |field| field.type == :file_field }
    end
    
    # 
    # Define the actions available to the form.  This can be either a list of symbols, or 
    # as a block.  The block form allows options to be passed to the actions.
    # 
    # Currently, the available actions are hardcoded.  I would like to make the actionlist
    # extensible somehow, but the available actions needs to to come with the corresponding
    # support in the controller methods.  Comments welcome.
    # 
    # Example: <tt>actions [:save, :save_and_add_another, :delete]</tt>
    # or:
    #   actions do
    #     save
    #     save_and_add_another, :name => "Save Post and create a new one"
    #   end
    #
    def actions(actionlist=nil, &block)
      if !actionlist.nil? or block_given? then
        @actions = Roar::Actions.new(actionlist, &block)
      end
      @actions
    end
  end    
end

