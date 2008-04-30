$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../../criteriaquery/lib'
require 'rubygems'
require 'active_support'
require 'breakpoint'
require 'query' 
%w(actions action column form field filter collection base).each { |klass| require "roar/#{klass}" }
require 'roar/rails/act_methods'
require 'roar/rails/base_controller'
require 'roar/settings'

