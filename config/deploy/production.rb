set :rails_env, "production"
set :deploy_to, "/var/www/dailybaby"

role :web, "dailybaby.web"
role :app, "dailybaby.web"
role :db,  "dailybaby.web", :primary => true

set :rvm_bin_path, "/usr/local/rvm/bin"