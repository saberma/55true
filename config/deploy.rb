set :application, "55true"
set :repository,  "git@github.com:saberma/55true.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :deploy_via, :remote_cache
set :git_shallow_clone, 1

#role :app, "your app-server here"
#role :web, "your web-server here"
#role :db,  "your db-server here", :primary => true
server "vps", :app, :web, :db, :primary => true

set :user, "saberma"
set :runner, nil
set :mongrel_conf, "#{deploy_to}/current/config/mongrel_cluster.yml"
set :mongrel_port, 3000

desc "link in production database"
task :after_update_code do
  run <<-CMD
  ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml
  ln -nfs #{deploy_to}/#{shared_dir}/photos #{release_path}/public/photos
  CMD
end
