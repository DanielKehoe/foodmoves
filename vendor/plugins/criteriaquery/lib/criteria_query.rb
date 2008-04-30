# CriteriaQuery
require 'query'

module Criteria
  module ActiveRecord

      def self.included(mod)
        mod.extend(ClassMethods)
      end

      module ClassMethods
        def query
          Criteria::Query.new(self)
        end
      end

  end
end

# reopen ActiveRecord and include the query method
ActiveRecord::Base.send(:include, Criteria::ActiveRecord)