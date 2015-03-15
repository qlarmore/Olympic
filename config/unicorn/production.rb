deploy_to = "/home/#{user}/olympic/current"
pid "#{deploy_to}/tmp/pids/unicorn.pid"
stderr_path "#{deploy_to}/log/unicorn.log"
stdout_path "#{deploy_to}/log/unicorn.log"

listen "/tmp/unicorn.olympic.sock"

timeout 120
worker_processes 4

preload_app true

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{rails_root}/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.connection.disconnect!
  $redis.quit

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
end


