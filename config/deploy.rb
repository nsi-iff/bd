$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
require "bundler/capistrano"
set :rvm_ruby_string, "ruby-1.9.3-p0@bd"
set :rvm_bin_path, "/usr/local/rvm/bin/"

set :application, "bd"
set :domain, "<your domain>"
set :deploy_to, "/var/www/#{application}"
set :user, "<your user>"
set :use_sudo, false

set :repository,  "https://github.com/nsi-iff/bd.git"
set :scm, :git
set :scm_verbose, true

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

set :normalize_asset_timestamps, false

namespace :utils do
  task :compile_assets do
    run "cd #{latest_release}; bundle exec rake assets:precompile --trace"
  end
  task :run_seed do
    run "cd #{latest_release}; bundle exec rake db:seed RAILS_ENV=production"
  end
  task :copy_config_file do
    run "cp -rf #{latest_release}/config/database.yml.example #{latest_release}/config/database.yml"
  end
end

namespace :bundle do
  task :install do; run "cd #{release_path} && bundle install --without test development --deployment"; end
end

namespace :db do
  task :create do; run "cd #{release_path}; rake db:create RAILS_ENV=production"; end
  task :migrate do; run "cd #{release_path}; rake db:migrate RAILS_ENV=production"; end
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

tasks = ["deploy:finalize_update", "utils:copy_config_file"]

after *tasks
after "deploy:update_code", "db:create", "db:migrate", "utils:compile_assets"
