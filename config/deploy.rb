require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/puma'
require 'mina_sidekiq/tasks'
require 'mina/scp'
require 'mina/foreman'

# Global settings
set :domain,       File.read(File.join(Dir.pwd, '.domain')).chomp
set :deploy_to,    '/home/deploy-it/deploy-it'
set :shared_paths, ['tmp/pids', 'tmp/sockets', 'log', '.env']

# Git settings
set :repository, 'https://github.com/jbox-web/deploy-it.git'
set :branch,     'master'

# SSH settings
set :user,          'deploy-it'
set :identity_file, File.join(Dir.home, '.ssh', 'mina')
set :forward_agent, true

# Sidekiq settings
set :sidekiq_pid, "#{deploy_to}/#{shared_path}/tmp/pids/sidekiq.pid"

# Puma settings
set :puma_config, "#{deploy_to}/#{current_path}/config/puma.rb"

# Foreman settings
set :application,      'deploy-it'
set :foreman_format,   'systemd'
set :foreman_location, '/lib/systemd/system'

# DeployIt settings
set :config_file, File.join(Dir.pwd, 'deploy-it.conf')

# RVM settings
task :environment do
  invoke :'rvm:use[ruby-2.2.4@default]'
end

##### TASKS #####

desc 'Create base directories'
task :setup do
  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/log")
  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/tmp/pids")
  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/tmp/sockets")
end


desc "Deploys the current version to the server."
task deploy: :environment do
  deploy do
    invoke :'sidekiq:quiet'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'deploy:install_config'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      invoke :'puma:restart'
      invoke :'sidekiq:restart'
      invoke :'faye:restart'
    end
  end
end


namespace :deploy do
  desc 'Copy DeployIt configuration file'
  task install_config: :environment do
    queue! %[
      echo '-----> Copying configuration file'
    ]
    scp_upload(config_file, "#{deploy_to}/#{shared_path}/.env")
  end
end


namespace :faye do
  set_default :faye_pid,    -> { "#{deploy_to}/#{shared_path}/tmp/pids/faye.pid" }
  set_default :faye_cmd,    -> { "#{bundle_prefix} thin" }
  set_default :faye_config, -> { 'config/danthes_thin.yml' }

  desc 'Start Faye'
  task start: :environment do
    queue! %[
      if [ -e '#{faye_pid}' ]; then
        echo 'Faye is already running!';
      else
        cd #{deploy_to}/#{current_path} && #{faye_cmd} start -d -C #{faye_config}
      fi
    ]
  end

  desc 'Restart Faye'
  task restart: :environment do
    queue! %[
      if [ -e '#{faye_pid}' ]; then
        cd #{deploy_to}/#{current_path} && #{faye_cmd} restart -d -C #{faye_config}
      else
        echo 'Faye is not running!';
      fi
    ]
  end

  desc 'Stop Faye'
  task stop: :environment do
    queue! %[
      if [ -e '#{faye_pid}' ]; then
        cd #{deploy_to}/#{current_path} && #{faye_cmd} stop -C #{faye_config}
        rm -f '#{faye_pid}'
      else
        echo 'Faye is not running!';
      fi
    ]
  end
end


namespace :foreman do
  namespace :systemd do
    set_default :foreman_dir, -> { "#{deploy_to}/#{current_path}" }

    desc 'Export the Procfile to systemd'
    task export: :environment do
      cmd = "sudo foreman export #{foreman_format} #{foreman_location} -a #{foreman_app} -u #{foreman_user} -d #{foreman_dir} -l #{foreman_log} -f #{foreman_dir}/#{foreman_procfile}"
      queue! %[
        echo "-----> Exporting foreman Procfile for #{foreman_app}"
        #{cmd}
      ]
    end


    desc 'Reload systemd'
    task reload: :environment do
      cmd = "sudo systemctl daemon-reload"
      queue! %[
        echo "-----> Reloading systemd"
        #{cmd}
      ]
    end


    desc 'Start application with systemd'
    task start: :environment do
      cmd = "sudo systemctl start #{foreman_app}.target"
      queue! %[
        echo "-----> Starting #{foreman_app} with systemd"
        #{cmd}
      ]
    end


    desc 'Restart application with systemd'
    task restart: :environment do
      cmd = "sudo systemctl restart #{foreman_app}.target"
      queue! %[
        echo "-----> Restarting #{foreman_app} with systemd"
        #{cmd}
      ]
    end


    desc 'Stop application with systemd'
    task stop: :environment do
      cmd = "sudo systemctl stop #{foreman_app}.target"
      queue! %[
        echo "-----> Stopping #{foreman_app} with systemd"
        #{cmd}
      ]
    end


    desc 'Enable application with systemd'
    task enable: :environment do
      cmd = "sudo systemctl enable #{foreman_app}.target"
      queue! %[
        echo "-----> Enabling #{foreman_app} with systemd"
        #{cmd}
      ]
    end


    desc 'Disable application with systemd'
    task disable: :environment do
      cmd = "sudo systemctl disable #{foreman_app}.target"
      queue! %[
        echo "-----> Disabling #{foreman_app} with systemd"
        #{cmd}
      ]
    end
  end
end
