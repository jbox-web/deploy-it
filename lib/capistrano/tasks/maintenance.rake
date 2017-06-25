namespace :maintenance do
  set :maintenance_page, 'public/maintenance.html'

  desc 'Start maintenance mode'
  task :start do
    on roles(:web) do |host|
      within shared_path do
        execute 'touch', 'tmp/maintenance.txt'
      end
    end
  end

  desc 'Stop maintenance mode'
  task :end do
    on roles(:web) do |host|
      within shared_path do
        execute 'rm', '-f', 'tmp/maintenance.txt'
      end
    end
  end

  desc 'Install maintenance page'
  task :install do
    on roles(:web) do |host|
      upload! fetch(:maintenance_page), "#{shared_path}/public/maintenance.html"
    end
  end
end
