require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/scp'
require 'mina/foreman'

# Global settings
set :domain,       File.read(File.join(Dir.pwd, '.domain')).chomp
set :deploy_to,    '/home/deploy-it/deploy-it'
set :shared_paths, ['tmp', 'log', '.env']

# Git settings
set :repository, 'https://github.com/jbox-web/deploy-it.git'
set :branch,     'master'

# SSH settings
set :user,          'deploy-it'
set :identity_file, File.join(Dir.home, '.ssh', 'mina')
set :forward_agent, true

# Nginx settings
set :nginx_config, File.join(Dir.pwd, 'deploy', 'nginx.conf')

# DeployIt settings
set :app_config, File.join(Dir.pwd, 'deploy', 'deploy-it.conf')

# Foreman settings
set :application,      'deploy-it'
set :foreman_format,   'systemd'
set :foreman_location, "#{deploy_to}/.config/systemd/user"
set :foreman_services, %w(web worker socket)

# RVM settings
task :environment do
  invoke :'rvm:use[ruby-2.3.1@default]'
end

##### TASKS #####

desc 'Create base directories'
task :setup do
  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/config")
  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/log")
  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/tmp")

  invoke :'foreman:systemd:setup'
  invoke :'foreman:systemd:export'
  invoke :'foreman:systemd:reload'
end


desc "Deploys the current version to the server."
task deploy: :environment do
  deploy do
    invoke :'maintenance:start'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'bundle:clean'
    invoke :'deploy:install_config'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      invoke :'foreman:systemd:restart'
      invoke :'maintenance:end'
    end
  end
end


namespace :deploy do
  desc 'Copy configuration file'
  task install_config: :environment do
    queue! %[
      echo '-----> Copying configuration file'
    ]
    scp_upload(app_config, "#{deploy_to}/#{shared_path}/.env")
    scp_upload(nginx_config, "#{deploy_to}/#{shared_path}/config/nginx.conf")
  end
end


namespace :bundle do
  desc "Clean gem dependencies using Bundler."
  task :clean do
    queue %{
      echo "-----> Cleaning gem dependencies"
      #{echo_cmd %[#{bundle_bin} clean]}
    }
  end
end


namespace :maintenance do
  set_default :maintenance_page, -> { 'public/maintenance.html' }

  desc "Start maintenance mode"
  task :start do
    queue %{
      echo "-----> Start maintenance mode"
      #{echo_cmd %[cd #{deploy_to}/#{current_path} && touch tmp/maintenance.txt]}
    }
  end

  desc "Stop maintenance mode"
  task :end do
    queue %{
      echo "-----> Stop maintenance mode"
      #{echo_cmd %[cd #{deploy_to}/#{current_path} && rm -f tmp/maintenance.txt]}
    }
  end

  desc 'Update maintenance page'
  task update: :environment do
    queue! %[
      echo '-----> Updating maintenance page'
    ]
    scp_upload(maintenance_page, "#{deploy_to}/#{shared_path}/public/maintenance.html")
  end
end


namespace :foreman do
  namespace :systemd do
    set_default :foreman_dir,      -> { "#{deploy_to}/#{current_path}" }
    set_default :foreman_services, -> { [] }

    desc 'Setup systemd'
    task setup: :environment do
      # Create Foreman templates directory
      queue! %{
        echo "-----> Setting up systemd"
        mkdir -p "#{deploy_to}/.foreman/templates/systemd"
        rvm repair wrappers
      }

      # Copy Foreman systemd templates
      %w(master.target.erb process.service.erb process_master.target.erb).each do |file|
        source = File.join(Dir.pwd, 'deploy', 'foreman', file)
        scp_upload(source, "#{deploy_to}/.foreman/templates/systemd/#{file}")
      end
    end


    desc 'Export the Procfile to systemd'
    task export: :environment do
      cmd = "#{bundle_prefix} foreman export #{foreman_format} #{foreman_location} -a #{foreman_app} -u #{foreman_user} -d #{foreman_dir} -l #{foreman_log} -f #{foreman_dir}/#{foreman_procfile} --timeout 30"
      queue! %[
        echo "-----> Exporting foreman Procfile for #{foreman_app}"
        cd #{deploy_to}/#{current_path} && #{cmd}
      ]
    end


    desc 'Reload systemd'
    task reload: :environment do
      cmd = "systemctl --user daemon-reload"
      queue! %[
        echo "-----> Reloading systemd"
        #{cmd}
      ]
    end


    desc 'Start application with systemd'
    task start: :environment do
      cmd = "systemctl --user start #{foreman_app}.target"
      queue! %[
        echo "-----> Starting #{foreman_app} with systemd"
        #{cmd}
      ]
    end


    desc 'Restart application with systemd'
    task restart: :environment do
      cmd = "systemctl --user restart #{foreman_app}.target"
      queue! %[
        echo "-----> Restarting #{foreman_app} with systemd"
        #{cmd}
      ]
    end


    desc 'Stop application with systemd'
    task stop: :environment do
      cmd = "systemctl --user stop #{foreman_app}.target"
      queue! %[
        echo "-----> Stopping #{foreman_app} with systemd"
        #{cmd}
      ]
    end


    desc 'Enable application with systemd'
    task enable: :environment do
      cmd = "systemctl --user enable #{foreman_app}.target"
      queue! %[
        echo "-----> Enabling #{foreman_app} with systemd"
        #{cmd}
      ]
    end


    desc 'Disable application with systemd'
    task disable: :environment do
      cmd = "systemctl --user disable #{foreman_app}.target"
      queue! %[
        echo "-----> Disabling #{foreman_app} with systemd"
        #{cmd}
      ]
    end


    desc 'Getting application status with systemd'
    task status: :environment do
      cmd = "systemctl --user status #{foreman_app}.target"
      queue! %[
        echo "-----> Getting #{foreman_app} status with systemd"
        #{cmd}
      ]

      foreman_services.each_with_index do |service, i|
        cmd = "systemctl --user status #{foreman_app}-#{service}@5#{i}00.service"

        queue! %[
          echo ''
          echo "-----> Getting #{foreman_app} #{service} status with systemd"
          #{cmd}
        ]
      end
    end
  end
end
