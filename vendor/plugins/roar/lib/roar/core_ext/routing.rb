module Roar
  module CoreExt
    module Resources
      #
      # Creates named routes for implementing resource routes for admin controllers.
      # By default, 
      #    :name_prefix => "roar_"
      #    :path_prefix => "/admin"
      #    :member => { :delete => "get"}
      #
      # Example:
      #
      #   map.roar :users
      #
      #   map.roar :leagues do |league|
      #     league.roar :divisions
      #   end
      #
      #   Will produce the routes:
      #      /admin/users, /admin/users/1;delete, /admin/users/new, etc.
      #      /admin/leagues, /admin/leagues/1;delete, /admin/leagues/new
      #      /admin/leagues/1/divisions, /admin/leagues/1/divisions/1;delete, etc.
      #
      def roar(*entities, &block)
        options = entities.last.is_a?(Hash) ? entities.pop : { }
        options[:name_prefix] = "roar_"
        options[:path_prefix] ||= "/admin"
        options[:member] ||= {}
        options[:member][:delete] ||= :get 
        entities.each { |entity| map_resource entity, options.dup, &block }
      end
    end
  end
end