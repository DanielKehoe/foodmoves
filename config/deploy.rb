# =============================================================================
# ENGINE YARD REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The deploy_to path must be the path on each machine that will
# form the root of the application path.

set :keep_releases, 5
set :application,   'foodmoves'
set :repository,    'http://foodmoves.unfuddle.com/svn/foodmoves_foodmoves/trunk'
set :scm_username,  'foodmoves_foodmoves'
set :scm_password,  '4roper2c'
set :user,          'foodmoves'
set :password,      'sl1vykesh5'
set :deploy_to,     "/data/#{application}"
set :deploy_via,    :export
set :monit_group,   'mongrel'
set :scm,           :subversion

# comment out if it gives you trouble. newest net/ssh needs this set.
# ssh_options[:paranoid] = false

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true. 
task :production do
  role :web, '65.74.139.2:8208'
  role :app, '65.74.139.2:8208'
  role :db, '65.74.139.2:8208', :primary => true
  role :app, '65.74.139.2:8207', :no_release => true, :no_symlink => true 
end

task :staging do
  role :web, '65.74.139.2:8209'
  role :app, '65.74.139.2:8209'
  role :db, '65.74.139.2:8209', :primary => true
  # added 12/12 to identify the staging server at Engine Yard
  set :rails_env, 'staging'
end

# =============================================================================
# TASKS
# Don't change unless you know what you are doing!
after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
after "deploy:update_code","deploy:symlink_configs"

# =============================================================================  
namespace :mongrel do
  desc <<-DESC
  Start Mongrel processes on the app server.  This uses the :use_sudo variable to determine whether to use sudo or not. By default, :use_sudo is
  set to true.
  DESC
  task :start, :roles => :app do
    sudo "/usr/bin/monit start all -g #{monit_group}"
  end

  desc <<-DESC
  Restart the Mongrel processes on the app server by starting and stopping the cluster. This uses the :use_sudo
  variable to determine whether to use sudo or not. By default, :use_sudo is set to true.
  DESC
  task :restart, :roles => :app do
    sudo "/usr/bin/monit restart all -g #{monit_group}"
  end

  desc <<-DESC
  Stop the Mongrel processes on the app server.  This uses the :use_sudo
  variable to determine whether to use sudo or not. By default, :use_sudo is
  set to true.
  DESC
  task :stop, :roles => :app do
    sudo "/usr/bin/monit stop all -g #{monit_group}"
  end
end

# =============================================================================
namespace :nginx do 
  desc "Start Nginx on the app server."
  task :start, :roles => :app do
    sudo "/etc/init.d/nginx start"
  end

  desc "Restart the Nginx processes on the app server by starting and stopping the cluster."
  task :restart , :roles => :app do
    sudo "/etc/init.d/nginx restart"
  end

  desc "Stop the Nginx processes on the app server."
  task :stop , :roles => :app do
    sudo "/etc/init.d/nginx stop"
  end

  desc "Tail the nginx logs for this environment"
  task :tail, :roles => :app do
    run "tail -f /var/log/engineyard/nginx/vhost.access.log" do |channel, stream, data|
      puts "#{channel[:host]}: #{data}" unless data =~ /^10\.0\.0/ # skips lb pull pages
      break if stream == :err    
    end
  end
end

# =============================================================================
# after "deploy:update_code","ferret:symlink_configs" # uncomment this to hook up configs by default
# after "deploy:symlink","ferret:restart"             # uncomment this to restart ferret drb after deploy
namespace :ferret do
  desc "After update_code you want to symlink the index and ferret_server.yml file into place"
  task :symlink_configs, :roles => :app, :except => {:no_release => true} do
    run <<-CMD
      cd #{release_path} &&
      ln -nfs #{shared_path}/config/ferret_server.yml #{release_path}/config/ferret_server.yml &&
      ln -nfs #{shared_path}/index #{release_path}/index
    CMD
  end
  [:start,:stop,:restart].each do |op|
    task op, :roles => :app, :except => {:no_release => true} do
      sudo "/usr/bin/monit #{op} all -g ferret_#{application}"
    end
  end
end

# =============================================================================
namespace(:deploy) do  
  task :symlink_configs, :roles => :app, :except => {:no_symlink => true} do
    run <<-CMD
      cd #{release_path} &&
      ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml &&
      ln -nfs #{shared_path}/config/mongrel_cluster.yml #{release_path}/config/mongrel_cluster.yml
    CMD
  end
  
  desc "Long deploy will throw up the maintenance.html page and run migrations 
        then it restarts and enables the site again."
  task :long do
    transaction do
      update_code
      web.disable
      symlink
      migrate
    end
  
    restart
    web.enable
  end

  desc "Restart the Mongrel processes on the app server by calling restart_mongrel_cluster."
  task :restart, :roles => :app do
    mongrel.restart
  end

  desc "Start the Mongrel processes on the app server by calling start_mongrel_cluster."
  task :spinner, :roles => :app do
    mongrel.start
  end

  desc "Tail the Rails production log for this environment"
  task :tail_production_logs, :roles => :app do
    run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
      puts  # for an extra line break before the host name
      puts "#{channel[:host]}: #{data}" 
      break if stream == :err    
    end
  end
end


# =============================================================================
# DK changed 11/1/07 per advice of Lee Jensen at Engine Yard,
# replaced next line:
# after "deploy:symlink","daemons:restart" # this will restart daemons after deploy
# with next two lines:
before "deploy:symlink", "daemons:stop"
after "deploy:symlink", "daemons:start"
namespace :daemons do
  desc "after deploy, restart daemons created by daemon_generator plugin"
  [:start,:stop,:restart].each do |op|
    task op, :roles => :app, :except => {:no_release => true} do
      sudo "/usr/bin/monit #{op} all -g daemons_#{application}"
      sleep 5 if op == :stop
    end
  end
end


# =============================================================================
set :production_database,'foodmoves_prod'
set :stage_database, 'foodmoves_stage'
set :sql_user, 'foodmoves_db'
set :sql_pass, 'sik0rok6'

# =============================================================================
set :local_prod_db, 'foodmoves_development' #local database
set :local_host, 'yourip.com' #you can use IP or dns name, must be ssh accessible from internet
set :local_sql_user, 'foodmoves' #local database username
set :local_sql_pass, '4roper2c' #local database pw


namespace :db do
  desc "Clone Production Database to Staging Database."
  task :clone_prod_to_stage, :roles => :db, :only => { :primary => true } do
    now = Time.now
    backup_time = [now.year,now.month,now.day,now.hour,now.min,now.sec].join('-')
    backup_file = "#{deploy_to}/production-snapshot-#{backup_time}.sql"
    on_rollback { delete backup_file }
    run "mysqldump --add-drop-table -u #{sql_user} -h mysql50-1 -p #{production_database} > #{backup_file}" do |ch, stream, out|
      ch.send_data sql_pass+"\n" if out =~ /Enter password:/
    end
    run "mysql -u #{sql_user} -p#{sql_pass} -h mysql50-1 #{stage_database} < #{backup_file}"
  end
  desc "Clone your remote database to the local machine"
  task :clone_prod_to_local, :roles => :db, :only => { :primary => true } do
   run `ssh #{local_host} "mysqldump --add-drop-table -u #{sql_user} -h mysql50-1 -p #{sql_pass} #{production_database} --skip-extended-insert | bzip2 " | bzcat | mysql -u root -p #{local_sql_user}`
  end
end
