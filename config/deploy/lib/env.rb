namespace :env do
  task :copy do
    envfile_path = File.expand_path "config/deploy/#{ stage }.env"
    remote_envfile_path = "#{ shared_path }/.env"

    # make sure the file exists
    run "if [ ! -e #{ remote_envfile_path } ]; then touch #{ remote_envfile_path }; fi;"

    if File.exists?( envfile_path )
      upload \
        envfile_path,
        remote_envfile_path
    end
  end
end

before 'dotenv:symlink' , 'env:copy'
