set :rails_env, "production"
set :deploy_to, "/var/www/production"

role :web, "dailybaby.production"
role :app, "dailybaby.production"
role :db,  "dailybaby.production", :primary => true

set :rvm_bin_path, "/usr/local/rvm/bin"