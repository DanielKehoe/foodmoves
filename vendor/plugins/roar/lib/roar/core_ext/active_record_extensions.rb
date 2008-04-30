module Roar
  module CoreExt
    module ActiveRecordExtensions
      def roar_crud_association(association_symbol, param_key_required=nil)
        attr_writer "edit_#{association_symbol}".to_sym, "new_#{association_symbol}".to_sym
        before_validation "roar_validate_#{association_symbol}".to_sym
        define_method("roar_validate_#{association_symbol}") do
          roar_validate_has_many(association_symbol, param_key_required)
        end
        after_save "roar_update_#{association_symbol}".to_sym
        define_method("roar_update_#{association_symbol}") do
          roar_update_has_many(association_symbol, param_key_required)
        end

      end

      def to_select(text_method=:name, conditions=nil)
        find(:all, :conditions => conditions).to_select(text_method)
      end
    end
  end
end
