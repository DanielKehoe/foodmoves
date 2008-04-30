# Reload plugin in dev mode if env variable is set
Dependencies.load_once_paths.delete(lib_path) if ENV["ROAR_RELOAD"]

ActionController::Base.send(:extend, Roar::Rails::ActMethods)
ActionController::Base.send(:include, Roar::Rails::BaseController)
ActionView::Base.send(:include, Roar::Rails::Helper)

class ActionController::Base
  def render_with_roar(options = nil, deprecated_status = nil, &block)
    if options && options.respond_to?(:[])
      if roar = options[:roar]
        options[:template] = roar_path(roar)
      elsif rjs = options[:roar_rjs]
        options[:template] = roar_path(rjs, :ext=>'.rjs')
      elsif partial = options[:roar_partial]
        path_options = options[:view] ? {:view => options[:view]} : {}
        options[:partial] = roar_path(partial, path_options.merge({:partial=>true}))
      end
    end
    render_without_roar(options, deprecated_status, &block)
  end
  
  alias_method_chain :render, :roar
end

class ActionView::Base
  def render_with_roar(options = {}, old_local_assigns = {}, &block) #:nodoc:
    if partial = options[:roar_partial]
      path_options = options[:view] ? {:view => options[:view]} : {}
      options[:partial] = roar_path(partial, path_options.merge({:partial=>true}))
    end
    render_without_roar(options, old_local_assigns, &block)
  end
  alias_method_chain :render, :roar
end


require 'roar/core_ext/routing'
ActionController::Routing::RouteSet::Mapper.send :include, Roar::CoreExt::Resources

ActiveRecord::Base.send :extend, Roar::CoreExt::ActiveRecordExtensions
ActiveRecord::Base.send :include, Roar::CoreExt::ActiveRecordIncludes

Array.send :include, Roar::CoreExt::Array

class ActionController::Base
  def self.roar_yui_ext(options={}, &block)
    roar({:layout=>"yui-ext", :view=>"yui-ext"}.merge(options), &block)
  end
  
  def self.roar_admin(options={}, &block)
    roar({:layout=>"roar"}.merge(options), &block)
  end
end