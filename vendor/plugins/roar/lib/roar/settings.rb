module Roar
  class Settings
    cattr_accessor :app_template_path
    @@app_template_path = "roar"

    cattr_accessor :default_template_path
    @@default_template_path = "/../../vendor/plugins/roar/views"
    
    cattr_accessor :template_paths
    @@template_paths = [@@app_template_path, @@default_template_path]
    
    # Default roar options
    cattr_accessor :roar_options
    @@roar_options = {:view=>"default", :subdomain=>nil, :parent=>[], :layout=>"roar", :prefix=>nil}
    
    def self.insert_template_path(path)
      @@template_paths.insert(0, path)
    end
  end
end