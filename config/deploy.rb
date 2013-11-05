require "rvm/capistrano"
require "bundler/capistrano"

set :application, "spinejs_ru"
set :repository, "git://github.com/tonic20/spine.site.git"
set :scm, :git

set :user, "deploy"
set :deploy_to, "/opt/spinejs.ru/"
set :shared_host, "leo.penzasoft.com"
set :keep_releases, 2
set :rvm_ruby_string, "1.9.3"

role :web, shared_host
role :app, shared_host
role :db,  shared_host, primary: true

after "deploy:update_code", "deploy:migrate"
after "deploy:update_code", "deploy:cleanup"
after "deploy:finalize_update", "deploy:config"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :config do
    run "cd #{release_path}/config && ln -s #{shared_path}/config/* ."
  end
end
