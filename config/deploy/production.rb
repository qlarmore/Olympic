# set :stage, :production

# # Replace 127.0.0.1 with your server's IP address!
# server '104.131.206.86', user: 'root', roles: %w{web app}

server '178.62.154.54', :app, :web, :db, :primary => true
set :deploy_to, "/home/#{user}/#{application}"
set :current, "#{deploy_to}/current"
set :branch, "production"

set :rails_env, "production"
set :unicorn_conf, "#{current}/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/tmp/pids/unicorn.pid"
set(:releases_path)     { File.join(deploy_to, version_dir) }
set(:shared_path)       { File.join(deploy_to, shared_dir) }
set(:current_path)      { File.join(deploy_to, current_dir) }
set(:release_path)      { File.join(releases_path, release_name) }

require 'capistrano-unicorn'