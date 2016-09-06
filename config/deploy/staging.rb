#server '10.98.241.14', :app, :web, :primary => true
role :web, "10.98.241.230"                          # Your HTTP server, Apache/etc
role :app, "10.98.241.230"                          # This may be the same as your `Web` server
role :db, "10.98.241.230" , :primary => true

set :rails_env, 'staging'
set :branch, '2015_rstaging'
