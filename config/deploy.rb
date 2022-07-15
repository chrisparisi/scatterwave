require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
require 'mina/rvm'    # for rvm support. (https://rvm.io)
require 'mina/bundler'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'Scatterwave'
set :domain, '159.203.184.73'


set :deploy_to, '/var/www/Scatterwave'
set :repository, 'git@gitlab.com:scatterwave/Scatterwave.git'
set :branch, 'master'

set :user, 'root'
set :rvm_use_path, '/usr/local/rvm/scripts/rvm'

set :keep_releases, '5'

# Optional settings:
#   set :user, 'foobar'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
# set :shared_dirs, fetch(:shared_dirs, []).push('public/assets')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')

set :shared_dirs, fetch(:shared_dirs, []).push('log').push('tmp').push('public/uploads')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/application.yml')


task :setup do
  command %[mkdir -p "#{fetch(:current_path)}/shared/log"]
  command %[chmod g+rx,u+rwx "#{fetch(:current_path)}/shared/log"]

  command %[mkdir -p "#{fetch(:current_path)}/shared/tmp"]
  command %[chmod g+rx,u+rwx "#{fetch(:current_path)}/shared/tmp"]

  command %[mkdir -p "#{fetch(:current_path)}/shared/config"]
  command %[chmod g+rx,u+rwx "#{fetch(:current_path)}/shared/config"]

  command %[touch "#{fetch(:current_path)}/shared/config/database.yml"]
  command  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  command %[mkdir -p "#{fetch(:current_path)}/shared/tmp/pids"]
  command %[chmod g+rx,u+rwx "#{fetch(:current_path)}/shared/tmp"]
  command %[chmod g+rx,u+rwx "#{fetch(:current_path)}/shared/tmp/pids"]

  command %[mkdir -p "#{fetch(:current_path)}/shared/tmp/sockets"]
  command %[chmod g+rx,u+rwx "#{fetch(:current_path)}/shared/tmp/sockets"]

  command %[mkdir -p "#{fetch(:current_path)}/shared/tmp/log"]
  command %[chmod g+rx,u+rwx "#{fetch(:current_path)}/shared/tmp/log"]

  command %[touch "#{fetch(:current_path)}/shared/config/application.yml"]
  command  %[echo "-----> Be sure to edit '#{fetch(:current_path)}/shared/config/application.yml'."]
end


# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use', 'ruby-1.9.3-p125@default'
  invoke :'rvm:use', 'ruby-2.3.0@default'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  # command %{rbenv install 2.3.0 --skip-existing}
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_create'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'rvm:use', 'ruby-2.3.0@default'
      invoke :'puma:restart'
      # invoke :'rvm:use', 'ruby-2.3.0@default'
      # invoke :'whenever:update'

      # in_path(fetch(:current_path)) do
      #   command %{mkdir -p tmp/}
      #   command %{touch tmp/restart.txt}
      # end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

namespace :puma do
  desc "Start the application"
  task :start do
    command 'echo "-----> Start Puma"'
    command "cd #{fetch(:current_path)} && RAILS_ENV=production bin/puma.sh start"
  end

  desc "Stop the application"
  task :stop do
    command 'echo "-----> Stop Puma "'
    command "cd #{fetch(:current_path)} && RAILS_ENV=production bin/puma.sh stop"
  end

  desc "Restart the application"
  task :restart do
    command "echo #{fetch(:current_path)}"
    command "cd #{fetch(:current_path)} && RAILS_ENV=production bin/puma.sh restart"
  end
end
