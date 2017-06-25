namespace :config do

  desc 'Install configuration files'
  task install: [:generate] do
    on roles(:app) do |host|
      config_files = fetch(:config_templates, [])
      execute :sudo, :cp, "#{shared_path}/config/nginx.conf",     "/etc/nginx/sites-enabled/#{fetch(:application)}.conf" if config_files.include?('nginx')
      execute :sudo, :cp, "#{shared_path}/config/syslog-ng.conf", "/etc/syslog-ng/conf.d/#{fetch(:application)}.conf"    if config_files.include?('syslog')
      execute :sudo, :cp, "#{shared_path}/config/logrotate.conf", "/etc/logrotate.d/#{fetch(:application)}"              if config_files.include?('logrotate')
    end
  end

  desc 'Generate configuration files'
  task :generate do
    on roles(:app) do |host|
      execute 'mkdir', '-p', "#{shared_path}/config"
      execute 'mkdir', '-p', "#{shared_path}/tmp/sockets"

      config_files = fetch(:config_templates, [])
      services     = fetch(:foreman_services, [])
      workers      = services.select { |s| s.include?('worker') }
      all_services = services.each_with_index.map do |service, index|
        if service.include?('worker') && workers.size > 1
          "#{service.split('_').first}#{index}"
        else
          service
        end
      end

      upload!  'deploy/application.conf', "#{shared_path}/.env"

      template 'systemd',         "#{deploy_to}/#{fetch(:application)}", 0755, locals: { services: services }
      template 'sudoers.conf',    "#{shared_path}/config/sudoers.conf"

      template 'nginx.conf',      "#{shared_path}/config/nginx.conf",      0644 if config_files.include?('nginx')
      template 'syslog-ng.conf',  "#{shared_path}/config/syslog-ng.conf",  0644 if config_files.include?('syslog')
      template 'logrotate.conf',  "#{shared_path}/config/logrotate.conf",  0644 if config_files.include?('logrotate')
    end
  end

end
