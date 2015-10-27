workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

tag         'deploy-it'
rackup      DefaultRackup
environment ENV['RAILS_ENV'] || 'development'

preload_app!

bind "tcp://127.0.0.1:#{(ENV['PORT'] || 5000)}"

if ENV['RAILS_ENV'] == 'production'
  daemonize            true
  pidfile              File.join(Dir.pwd, 'tmp', 'pids', 'puma.pid')
  state_path           File.join(Dir.pwd, 'tmp', 'sockets', 'puma.state')
  activate_control_app "unix://#{File.join(Dir.pwd, 'tmp', 'sockets', 'pumactl.sock')}"
  stdout_redirect      File.join(Dir.pwd, 'log', 'puma.stdout.log'), File.join(Dir.pwd, 'log', 'puma.stderr.log')

  on_worker_boot do
    ActiveRecord::Base.establish_connection
  end
end
