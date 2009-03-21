load 'deploy' if respond_to?(:namespace) # cap2 differentiator

default_run_options[:pty] = true

# be sure to change these
set :user, 'tribble'
set :domain, 'nyerm.com'
set :application, 'buttonator'

# the rest should be good
set :repository,  "#{user}@#{domain}:sites/git.nyerm.com/#{application}.git" 
set :deploy_to, "/home/#{user}/sites/#{application}.#{domain}" 
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :use_sudo, false

server domain, :app, :web

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt" 
  end
end
