set :stages, %w(production staging)
set :default_stage, "production"
require 'capistrano/ext/multistage'
require 'bundler/capistrano'

# set :whenever_command, "bundle exec whenever"
# set :whenever_environment, defer { stage }
# require 'whenever/capistrano'

set :application, 'dailybaby'

# RVM bootstrap
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3@dailybaby'              # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "enable"       # more info: rvm help autolibs
set :rvm_install_with_sudo, true
set :rvm_type, :system
before 'deploy:setup', 'rvm:install_rvm'   # install RVM
before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset
before 'deploy:setup', 'rvm:create_gemset' # only create gemset

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
# set :deploy_via, :remote_cache
set :user, "passenger"
set :use_sudo, false

# repo details
set :scm, :git
#set :scm_username, "?"
set :repository, "git@github.com:kcbigring/dailybaby.git"
set :branch, "master"
set :git_enable_submodules, 1

# asset handling
load 'deploy/assets'

# tasks
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :link_db do
    run "ln -s #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  end
  
end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

before 'deploy:assets:precompile', 'deploy:link_db'
after 'deploy:update_code', 'rvm:trust_rvmrc', 'deploy:migrate'
