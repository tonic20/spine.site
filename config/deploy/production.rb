set :rails_env, "production"

set :user, "deploy"
set :deploy_to, "/opt/spinejs.ru/"
set :shared_host, "penzasoft.com"

role :web, shared_host
role :app, shared_host
role :db,  shared_host, :primary => true

set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"