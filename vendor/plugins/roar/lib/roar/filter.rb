module Roar
  #
  # A filter
  #
  # Options:
  # * +label+: Override the label for the filter
  class Filter
    attr_accessor :name, :type, :label, :options
    def initialize(type, name, options={})
      self.label = options.has_key?(:label) ? options[:label] : name.to_s.humanize
      self.options = options
      self.type = type
      self.name = name
    end    
  end
end