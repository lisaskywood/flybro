# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.    
require "rvm/capistrano"
set :rvm_ruby_string, '1.9.2'
set :rvm_type, :user  # Don't use system-wide RVM

require 'bundler/capistrano'

set :application, 'meishifeige.com'
set :domain,      '58.215.177.42' #ucheke.com  50.57.160.177
set :project,     'flybro'

set :user, 'deploy'

# Setup git
set :scm, :git
set :scm_username, 'lisaskywood'
set :repository, "git@github.com:#{scm_username}/#{project}.git"
set :branch, 'master'

set :deploy_to, "/var/www/apps/#{application}"
set :deploy_via, :remote_cache

# Setup database
set :db_type, "mongodb"

# Setup user level
set :run, user
set :use_sudo, false

# Setup roles
role :app, domain
role :web, domain
role :db,  domain, :primary => true

# Some helpers from peepcode
class Capistrano::Configuration
  # Print an informative message with asterisks.
  def inform(message)
    puts "#{'*' * (message.length + 4)}"
    puts "* #{message} *"
    puts "#{'*' * (message.length + 4)}"
  end
 
  # Read a file and evaluate it as an ERB template.
  # Path is relative to this file's directory.
  def render_erb_template(filename)
    template = File.read(filename)
    result   = ERB.new(template).result(binding)
  end
  
  # Run a command and return the result as a string.
  def run_and_return(cmd)
    output = []
    run cmd do |ch, st, data|
      output << data
    end
    return output.to_s
  end
end

namespace :gems do
  desc "Show installed gems"
  task :default do
    run "gem list"
  end
  
  desc "Show gems, cleanly"
  task :stream do
    stream 'gem list'
  end
end

# Thin start, stop and restart
namespace :deploy do
  desc "start thin"
  task :start, :roles => :app do
    run "cd #{current_path}; bundle exec thin start -e production -d"
  end
  task :stop, :roles => :app do
    run "cd #{current_path}; bundle exec thin stop -e production"
  end
end

namespace :assets do
  desc "Precompile assets"
  task :precompile do
    stream "cd #{current_release}; bundle exec rake assets:precompile"
  end
end
after("deploy:update", "assets:precompile")

namespace :log do
  desc "Returns last lines of log file. Usage: cap log [-s lines=100] [-s rails_env=production]"  
  task :default do
    lines     = variables[:lines] || 100
    rails_env = variables[:rails_env] || 'production'  
    run "tail -n #{lines} #{shared_path}/log/#{rails_env}.log" do |ch, stream, out|  
      puts out  
    end
  end

  desc "Tails production log file"  
  task :tail, :roles => :app do
    stream "tail -f #{shared_path}/log/production.log"
  end
end

# http://www.mail-archive.com/capistrano@googlegroups.com/msg07356.html
default_run_options[:pty] = true
