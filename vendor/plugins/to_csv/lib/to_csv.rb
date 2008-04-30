# register Mime::CSV as 'text/csv' with synonym 'text/c-s-v'
class ActionController::Base
  Mime::Type.register 'text/csv', :csv, %w('text/comma-separated-values')
end

module ActiveSupport
  module CoreExtensions
    module Array
      module Conversions
        
        require 'csv'
        
        def to_csv(options={})
          raise ArgumentError, "Can only call argument on a collection of ActiveRecord objects" unless first.class.ancestors.include? ActiveRecord::Base
          raise ArgumentError, "Objects in collection are not all of the same class" unless all_elements_are?(first.class)
          
          options[:delimiter] ||= ','
          
          # Header row is optional, and can be disabled with :header => false
          header = options.delete(:header)
          
          # Get attributes into right order based on options
          # Can explicitly specifiy order with the :order option
          order = options.delete(:order)
          if options[:except] and options[:only]
            raise ArgumentError, "Options specify both :except and :only (#{options.keys.inspect})"
          elsif except = options[:except]
            ordered_keys = sort_like(first.attributes(options).keys, (order || first.class.column_names))
          elsif only = options[:only]
            ordered_keys = sort_like(first.attributes(options).keys, (order || only))
          else
            ordered_keys = sort_like(first.attributes.keys, (order || first.class.column_names))        
          end
          str = ''
          CSV::Writer.generate(str, options[:delimeter]) do |csv|
            unless header == false then csv << ordered_keys end
            each do | record |
              # Get values into right order
              ordered_values = []
              ordered_keys.each do |key|
                ordered_values << record.send(key)
              end
              csv << ordered_values
            end
          end 
          str
        end
        
        private
        
        def all_elements_are?(klass)
          self.inject(true) {|same, n| same && n.instance_of?(klass)}
        end
        
        def sort_like(array,order_model)
          # Make sure we add any items not specified in the order model to the end of the array
          array.sort_by { |record| (order_model.reverse.index(record) ? order_model.reverse.index(record)+1 : nil) || 0 }.reverse
        end

      end
    end
  end
end