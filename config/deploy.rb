# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'first_app'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/first_app'

# Default value for :scm is :git
set :scm, :git
set :branch, "master"
set :scm_user, "thomas.gauvin@modisfrance.fr"
set :scm_passphrase, "T@mbcg010"
set :repo_url, "https://github.com/tgauvin/first_app.git"

set :user, "developer"
set :use_sudo, false
set :rails_env, "production"
set :deploy_via, :copy
set :ssh_options, { :forward_agent => true, :port => 22 }
set :keep_releases, 5
set :pty, true
set :scm_verbose, true
role :app, "localhost"
role :web, "localhost"
role :db, "localhost", :primary => true

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  task :start do ; end
  task :stop do ; end

  # NOTE: I don't use this anymore, but this is how I used to do it.
  desc "Precompile assets after deploy"
  on roles :precompile_assets do
    execute <<-CMD
      cd #{ current_path } &&
      #{ sudo } bundle exec rake assets:precompile RAILS_ENV=#{ rails_env }
    CMD
  end

  desc "Restart applicaiton"
  on roles :restart do
    execute :sudo, "touch #{ File.join(current_path, 'tmp', 'restart.txt') }"
  end
end


after "deploy", "deploy:restart"
after "deploy", "deploy:cleanup"
