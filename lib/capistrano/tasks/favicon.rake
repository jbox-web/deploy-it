namespace :favicon do
  set :favicon, 'app/assets/images/favicons/favicon.ico'

  desc 'Install favicon'
  task :install do
    if File.exist?(fetch(:favicon))
      on roles(:web) do |host|
        upload! fetch(:favicon), "#{shared_path}/public/favicon.ico"
      end
    end
  end
end
