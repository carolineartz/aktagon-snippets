require 'dotenv'
Dotenv.load ".deployment.env"
require 'mina/git'
require 'mina/bundler'
require 'mina/whenever'
# http://nadarei.co/mina/docs/lib/mina/rbenv.html
require 'mina/rbenv'
require 'mina/rails'

set :sudo, true
set :term_mode, :system
#set :bash_options, 'RACK_ENV=production'

set :domain, ENV.fetch('DEPLOY_DOMAIN')
set :port, ENV.fetch('DEPLOY_SSH_PORT')

set :user, 'deploy'
set :repository, ENV.fetch('DEPLOY_GIT_REPO') 
set :deploy_to, ENV.fetch('DEPLOY_DIRECTORY') 
#set :rvm_path, '/usr/local/rvm/bin/rvm'
set :shared_paths, ['log', 'tmp', 'config/database.yml', '.production.env', '.env']
set :unicorn_pid, "#{deploy_to}/current/tmp/pids/unicorn.pid"

task :environment do
  invoke :'rbenv:load'
end

task :deploy => :environment do
  deploy do
    invoke 'git:clone'
    invoke 'deploy:link_shared_paths'
    invoke 'bundle:install'
    invoke 'assets:precompile'
    invoke 'db:migrate'
    #invoke :'whenever:update'
    to :launch do
      invoke 'unicorn:restart'
      invoke 'deploy:cleanup'
      invoke 'cache:clear'
    end
  end
end

def rake(cmd)
  queue! "cd #{deploy_to!}/#{current_path} && RACK_ENV=production bundle exec rake #{cmd}"
end

namespace :assets do
  task :precompile => :environment do
    queue! 'RACK_ENV=production bundle exec rake assets:precompile'
  end
end

namespace :db do
  task :migrate => :environment do
    queue! 'RACK_ENV=production bundle exec rake db:migrate'
  end
end

namespace :unicorn do
  task :stop => :environment do
    queue! "script/unicorn stop"
  end
  task :start => :environment do
    queue! "script/unicorn start"
  end
  task :restart => :environment do
    queue! "script/unicorn upgrade"
  end
end

namespace :cache do
  task :clear => :environment do
    rake 'cache:clear'
  end
end
