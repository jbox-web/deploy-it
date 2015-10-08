workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

if ENV['RACK_ENV'] == 'production'
  preload_app!

  daemonize       true
  pidfile         File.join(Dir.pwd, 'tmp', 'pids', 'puma.pid')
  state_path      File.join(Dir.pwd, 'tmp', 'sockets', 'puma.state')
  bind            "unix://#{File.join(Dir.pwd, 'tmp', 'sockets', 'puma.sock')}"
  stdout_redirect File.join(Dir.pwd, 'log', 'puma.stdout.log'), File.join(Dir.pwd, 'log', 'puma.stderr.log')

  on_worker_boot do
    ActiveRecord::Base.establish_connection
  end
end