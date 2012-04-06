$:.unshift(File.expand_path("./lib", ENV["rvm_path"]))
require "rvm/capistrano"
require "bundler/capistrano"

set :stages, %w(production)
set :default_stage, "production"
require "capistrano/ext/multistage"

default_run_options[:pty] = true

set :application, "spinejs_ru"

set :scm, "git"
set :repository, "git://github.com/tonic20/spine.site.git"
set :branch, "master"

set :keep_releases, 2
set :use_sudo, false
set :cap_env, "prod"

set :rvm_ruby_string, "1.9.2"
set :rvm_type, :user

after "deploy:update_code", "deploy:config"
# after "deploy:update_code", "deploy:migrate"
after "deploy:update", "deploy:cleanup"

# Compile assets
before "deploy:symlink", "deploy:assets"

namespace :deploy do
  task :restart do
    run "sudo sv restart spinejs"
  end

  task :start do
    run "sudo sv start spinejs"
  end

  task :stop do
    run "sudo sv stop spinejs"
  end

  task :config do
    run "cd #{release_path}/config && ln -s #{shared_path}/config/* ."
  end

  task :assets do
    run_rake "assets:precompile"
  end
end

def run_rake(cmd, options={}, &block)
  command = "cd #{release_path} && /usr/bin/env bundle exec rake #{cmd} RAILS_ENV=#{rails_env}"
  run(command, options, &block)
end

# Update data
namespace :update do
  desc "Copy remote shared files to localhost"
  task :shared do
    run_locally "rsync --recursive --times --rsh=ssh --compress --human-readable --progress #{user}@#{shared_host}:#{shared_path}/system/ public/system"
  end

  desc "Copy remote postgresql database to localhost"
  task :postgresql do
    get("#{current_path}/config/database.yml", "tmp/database.yml")

    remote_settings = YAML::load_file("tmp/database.yml")[rails_env]
    local_settings  = YAML::load_file("config/database.yml")["development"]

    run "export PGPASSWORD=#{remote_settings["password"]} && pg_dump --host=#{remote_settings["host"]} --port=#{remote_settings["port"]} --username #{remote_settings["username"]} --file #{current_path}/tmp/#{remote_settings["database"]}_dump -Fc #{remote_settings["database"]}"

    run_locally "rsync --recursive --times --rsh=ssh --compress --human-readable --progress #{user}@#{shared_host}:#{current_path}/tmp/#{remote_settings["database"]}_dump tmp/"

    run_locally "export PGPASSWORD=#{local_settings["password"]} && dropdb -U #{local_settings["username"]} --host=#{local_settings["host"]} --port=#{local_settings["port"]} #{local_settings["database"]}"
    run_locally "export PGPASSWORD=#{local_settings["password"]} && createdb -U #{local_settings["username"]} --host=#{local_settings["host"]} --port=#{local_settings["port"]} -T template0 #{local_settings["database"]}"
    run_locally "export PGPASSWORD=#{local_settings["password"]} && pg_restore -U #{local_settings["username"]} --host=#{local_settings["host"]} --port=#{local_settings["port"]} -d #{local_settings["database"]} tmp/#{remote_settings["database"]}_dump"
  end

  desc "Dump all remote data to localhost"
  task :all do
    update.shared
    update.postgresql
  end
end