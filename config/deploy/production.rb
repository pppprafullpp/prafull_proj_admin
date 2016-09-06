#server '10.98.103.242', :app, :web, :db, :primary => true
role :web, "0.0.0.0"                          # Your HTTP server, Apache/etc
role :app, "0.0.0.0"                          # This may be the same as your `Web` server
role :db, "0.0.0.0" , :primary => true

set :rails_env, 'production'
set :branch, "master"
