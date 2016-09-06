#require 'capistrano/maintenance' 
#require 'capistrano-unicorn'
#require "delayed/recipes"  

set :stages, %w(production testing staging)
set :default_stage, "testing"

require 'capistrano/ext/multistage' 

set :application, "servicedeals"
set :repository,  ""
set :maintenance_template_path, 'public/maintenance.html'

set :scm, :git

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :user, "root"
set :use_sudo, false
ssh_options[:forward_agent] = true

#role :web, "10.98.241.14"                          # Your HTTP server, Apache/etc
#role :app, "10.98.241.14"                          # This may be the same as your `Web` server
#role :db, "10.98.241.14" , :primary => true   # done because 14 is app server which runs migrations for test instance to 101  
#role :db,  "10.98.241.101", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"
#set :rails_env, 'test'
ssh_options[:auth_methods] = %w(password keyboard-interactive) 
default_run_options[:pty] = true 
set :deploy_to, "/var/www/html/servicedeals"
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :deploy do
  task :create_folder do

  end
  
  task :symlink_data, :roles => :app do

  end
  
  
  task :update_configs, :roles => :app do

  end
  
  #TODO
  #chown -R apache:apache attachment
  
  task :permissions do

  end  
  
  task :bundle_install do
    run "cd #{current_path}; bundle install"    
  end
  
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end


  task :assets_compile do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"    
  end

  task :restart_memcache do
    run "/etc/init.d/memcached restart"    
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
     run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end  
  
  task :uname do
    run "uname -a"
  end
#  task :start do
#    run <<-CMD
#      cd #{current_path}
      #export JAVA_HOME=/usr/lib/jvm/java-openjdk/
      #thin start  -d -e test -p 80
    #CMD
#  end
#  task :stop do
#    run <<-CMD
#      cd #{current_path}
      #export JAVA_HOME=/usr/lib/jvm/java-openjdk/
      #thin stop  -d -e test -p 80
    #CMD
#  end 
end
#namespace :gems do
#  task :install do
#    run " rake gems:install"
#  end
#end


#after "deploy", "deploy:web:disable" 
after "deploy", "deploy:bundle_install" 
#after "deploy", "deploy:update_configs"
after "deploy", "deploy:assets_compile"
#after "deploy", "deploy:symlink_data"
#after "deploy", "deploy:permissions"
after "deploy", "deploy:migrate"
#after "deploy", "unicorn:reload"
#after "deploy", "deploy:restart_memcache"
#after "deploy", "delayed_job:restart"
#after "deploy", "deploy:web:enable"
