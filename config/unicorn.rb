#et path to application
#app_dir = File.expand_path("../..", __FILE__)
#shared_dir = "#{app_dir}/shared"
app_dir = "/var/www/html/servicedeals/current"
working_directory app_dir


# Set unicorn options
worker_processes 2
preload_app true
timeout 30

# Set up socket location
listen "#{app_dir}/tmp/sockets/unicorn.sock", :backlog => 64

# Logging
stderr_path "#{app_dir}/log/unicorn.stderr.log"
stdout_path "#{app_dir}/log/unicorn.stdout.log"

# Set master PID location
pid "#{app_dir}/tmp/pids/unicorn.pid"