module Roar::Rails
  # BaseController is mixed into ActionContrlller::Base, so that roar_path is accessible,
  # even if roar has not been mixed in.  This lets us use Roar forms from other controllers.
  module BaseController
    def self.included(base)
      base.helper_method :roar_path, :rdom_class, :rdom_id, :rsingular_class_name
      base.class_inheritable_accessor :roar_options
      base.roar_options = {}
    end
    
    def rdom_class(record_or_class, prefix=nil)
      parent = (respond_to?(:has_parent?) && has_parent?) ? params["#{roar.parent.first}_id".to_sym] : nil
      name = [rsingular_class_name(record_or_class), parent].compact * '_'
      [ prefix, name ].compact * '-'
    end
    
    def rdom_id(record, prefix=nil)
      prefix ||= 'new' if record.new_record?
      parent = (respond_to?(:has_parent?) && has_parent?) ? params["#{roar.parent.first}_id".to_sym] : nil
      name = [rsingular_class_name(record), parent].compact * '_'
      [ prefix, name, record.id].compact * '-'
    end
    
    #
    # 
    def roar_path(template, options = {})
      view = (respond_to?(:roar) and !roar.nil?) ? roar.view : Roar::Settings.roar_options[:view]
      key = (respond_to?(:roar) and !roar.nil?) ? roar.key : nil
      options = {:ext=>'.rhtml', :view => view}.merge(options)
      options.merge!(:view => params[:view]) if params[:view]
      template_file = options[:partial] ? \
        (template.split("/")[0..-2] + ["_#{template.split("/").last}"]).join("/") : template
  
      viewpath = [RAILS_ROOT, 'app', 'views']
      apppath = viewpath + [controller_path]
      apppath += [key.to_s] unless key.nil?
  
      template = "#{template}.rjs" if options[:ext] == ".rjs"
      localtemplate = key.blank? ? template : "#{key}/#{template}"
  
      # File exists in the app directory
      if File.exist?(File.join(*[apppath,template_file+options[:ext]]))
        return "#{controller_path}/#{localtemplate}"
      end

      [options[:view],"default"].uniq.each do |view|
        # Test template_paths with given view
        Roar::Settings.template_paths.each { |path|
          filepath = File.join(*[viewpath,path,view,"#{template_file}#{options[:ext]}"])
          return File.join(path,view,template) if File.exist?(filepath)
        }
      end

      # No template found
      return localtemplate
    end
  private
    def rsingular_class_name(record_or_class)
      klass = record_or_class.is_a?(Class) ? record_or_class : record_or_class.class
      klass.name.underscore.tr('/', '_')
    end  
  end
end