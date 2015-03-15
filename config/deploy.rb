require "rvm/capistrano"
require 'bundler/capistrano'
require 'capistrano'
require "capistrano_colors"
require './config/boot'
require 'capistrano/ext/multistage'

Capistrano::Configuration::Namespaces::Namespace.class_eval do
  def capture(*args)
    parent.capture *args
  end
end

set :rvm_type, :system
set :rvm_bin_path, "/usr/local/rvm/bin"
set :keep_releases, 5
set :application, "olympic"
set :repository,  "git@bitbucket.org:qlarmore/olympic.git"
set :account, "deploy"
set :stages, %w( production )
set :default_stage, "production"
set :ssh_options, { :forward_agent => true }
set :scm, :git
set :use_sudo, false
set :user, account
set :deploy_via, :remote_cache
set :copy_exclude, [ '.git' ]

after "deploy", "deploy:cleanup" # keep only the last 5 releases
# before "deploy", "deploy:stop_websocket"
# before "deploy:migrations", "deploy:stop_websocket"
# after "deploy", "deploy:start_websocket"
# after "deploy:migrations", "deploy:start_websocket"

namespace :forever do
  desc "Start forever server"
  task :start do
    run "cd #{current_path}/node && NODE_ENV=production node_modules/.bin/forever start index.js"
  end

  desc "Stop forever server"
  task :stop do
    run "cd #{current_path}/node && NODE_ENV=production node_modules/.bin/forever stop index.js"
  end

  desc "Restart forever server"
  task :restart do
    run "cd #{current_path}/node && NODE_ENV=production node_modules/.bin/forever restart index.js"
  end
end

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} websocket server"
    task "#{command}_websocket", roles: :app, except: {no_release: true} do
      run "cd #{current_path} && bundle exec rake websocket_rails:#{command}_server RAILS_ENV=#{rails_env}"
    end
  end

  task :setup_config, roles: :app do
    run "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    run "ln -nfs #{current_path}/config/unicorn/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

end