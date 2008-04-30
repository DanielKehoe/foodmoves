require 'authorization/logic_parser'
require 'authorization/role_handler'
require 'authorization/access_control'

# 
 ActionController::Base.send :include, Authorization
 ActionController::Base.send :include, Authorization::AccessControl

