namespace :foreman do
  after  'foreman:export', 'foreman:reload'

  desc 'Setup systemd'
  task :install do
    on roles fetch(:foreman_roles) do |host|
      # Create Foreman templates directory
      execute 'mkdir', '-p', "#{fetch(:deploy_it_home)}/.foreman/templates/systemd"

      # Copy Foreman systemd templates
      %w(master.target.erb process.service.erb process_master.target.erb).each do |file|
        source = "config/deploy/templates/shared/foreman/#{file}"
        upload! source, "#{fetch(:deploy_it_home)}/.foreman/templates/systemd/#{file}"
      end
    end
  end


  desc 'Reload systemd'
  task :reload do
    on roles fetch(:foreman_roles) do |host|
      execute 'systemctl', '--user', 'daemon-reload'
    end
  end


  desc 'Getting application status with systemd'
  task :status do
    on roles fetch(:foreman_roles) do
      execute 'systemctl', '--user', 'status', "#{fetch(:application)}.target"

      fetch(:foreman_services).each_with_index do |service, i|
        execute 'systemctl', '--user', 'status', "#{fetch(:application)}-#{service}@5#{i}00.service"
      end
    end
  end


  desc 'Enable application with systemd'
  task :enable do
    on roles fetch(:foreman_roles) do |host|
      execute 'systemctl', '--user', 'enable', "#{fetch(:application)}.target"
    end
  end


  desc 'Disable application with systemd'
  task :disable do
    on roles fetch(:foreman_roles) do |host|
      execute 'systemctl', '--user', 'disable', "#{fetch(:application)}.target"
    end
  end


  # Override original method to add our systemd arguments.
  def foreman_exec(*args)
    if args.first == :foreman
      execute *args
    else
      args.shift
      execute 'systemctl', '--user', *args
    end
  end
end
