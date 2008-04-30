module Roar
  module CoreExt
    module ActiveRecordIncludes
      def to_roar_s
        name = self.title if self.respond_to?(:title)
        name ||= self.name if self.respond_to?(:name)
        name || "#{self.class} #{self.id}"
      end
      
      def roar_validate_has_many(association_symbol, param_key_required=nil)
        reflection = self.class.reflect_on_association(association_symbol)
        (instance_variable_get("@edit_#{association_symbol}") || {}).each { |key, params| 
          if param_key_required && !params[param_key_required].empty?
            association = reflection.klass.find(key)
            association.attributes = params
            errors.add(association_symbol, "Invalid") and return false unless association.valid?
          end
        }
        (instance_variable_get("@new_#{association_symbol}") || {}).each { |params|
          if (param_key_required.nil? || (params.has_key?(param_key_required) && !params[param_key_required].empty?))  && !reflection.klass.new(params).valid?
            errors.add(association_symbol, "Invalid") and return false 
          end
        }
      end

      def roar_update_has_many(association_symbol, param_key_required=nil)
        reflection = self.class.reflect_on_association(association_symbol)
        edits = (instance_variable_get("@edit_#{association_symbol}") || {})
        send(association_symbol).each { |association| association.destroy if !edits.has_key?(association.id.to_s) }
        edits.each { |key, params| 
          reflection.klass.find(key).update_attributes(params)
        }
        (instance_variable_get("@new_#{association_symbol}") || {}).each { |params|
          if param_key_required.nil? || (params.has_key?(param_key_required) && !params[param_key_required].empty?)
            send(association_symbol) << reflection.klass.create(params) 
          end
        }
        send(association_symbol).reset
      end
    end
  end
end
