rails_env = ENV['RAILS_ENV'] || 'production'

worker_processes 2
user 'deploy', 'deploy'

preload_app true
timeout 30

working_directory "/var/www/snippets/current"
listen "/tmp/snippets.socket", :backlog => 64

pid './tmp/pids/unicorn.pid'
stderr_path "/var/www/snippets/current/log/unicorn.stderr.log"
stdout_path "/var/www/snippets/current/log/unicorn.stdout.log"


before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  #if defined?(ActiveRecord::Base)
    #ActiveRecord::Base.connection.disconnect!
  #end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  #if defined?(ActiveRecord::Base)
    #ActiveRecord::Base.establish_connection
  #end

  child_pid = server.config[:pid].sub('.pid', ".#{worker.nr}.pid")
  system("echo #{Process.pid} > #{child_pid}")
end
