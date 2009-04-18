require 'deprec'

set :domain, "55true.com"
set :application, "55true"
set :repository,  "git://github.com/saberma/55true.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :deploy_via, :remote_cache
set :git_shallow_clone, 1

set :ruby_vm_type, :mri
set :web_server_type, :nginx
set :app_server_type, :mongrel
set :db_server_type, :mysql

role :app, domain
role :web, domain
role :db,  domain, :primary => true
set :database_yml_in_scm, false

set :user, "saberma"
set :runner, nil
set :mongrel_conf, "#{deploy_to}/current/config/mongrel_cluster.yml"
set :mongrel_port, 5000

set :gems_for_project, %w{rspec hoe haml paperclip mislav-will_paginate mysql mongrel mongrel_cluster cucumber webrat}

namespace :deploy do
  task :restart, :roles => :app, :except => {:no_release => true } do
    top.deprec.app.restart
  end
end

=begin
desc "link in production database"
task :after_update_code do
  run <<-CMD
  ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml
  ln -nfs #{deploy_to}/#{shared_dir}/photos #{release_path}/public/photos
  CMD
end
=end
