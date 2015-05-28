#worker_processes 2
worker_processes 1
preload_app true
# preload_app false
timeout 30
listen 3001
listen "/tmp/unicorn.web.sock"
stdout_path "/var/log/unicorn/stdout.log"
stderr_path "/var/log/unicorn/stderr.log"

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end
