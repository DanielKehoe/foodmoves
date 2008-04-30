namespace :roar do
  
  PLUGIN_ROOT = File.dirname(__FILE__) + '/../'
  
  desc 'Installs required javascript, css, images and layouts to the app.'
  task :install do
    assets_dir = File.join(PLUGIN_ROOT, 'assets')
    ["images","stylesheets", "javascripts"].each do |subdir|
      FileList["#{assets_dir}/#{subdir}/roar/**/*"].each { |file|
        destdir = File.join(RAILS_ROOT, 'public', File.dirname(file)[assets_dir.size..-1])
        FileUtils.mkdir_p(destdir)
        FileUtils.cp(file, destdir, :verbose=>true) unless File.directory?(file)
      }
    end
    FileUtils.cp(Dir[File.join(PLUGIN_ROOT,'views','layouts','*')], \
      File.join(RAILS_ROOT,'app','views','layouts'), :verbose=>true)
  end    
    
  desc 'Removes the javascripts, css, and images for the plugin.  layouts are left?'
  task :remove do
    ["images","stylesheets", "javascripts"].each do |subdir|
      FileUtils.rm_r(File.join(RAILS_ROOT, 'public', subdir, 'roar'))
    end
  end  
end