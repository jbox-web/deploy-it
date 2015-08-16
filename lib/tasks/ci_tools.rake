task stats: 'deploy_it:statistics:stats'

namespace :deploy_it do

  namespace :statistics do
    task :stats do
      require 'rails/code_statistics'
      ::STATS_DIRECTORIES << ["Contexts", "app/contexts"]
      ::STATS_DIRECTORIES << ["Forms", "app/forms"]
      ::STATS_DIRECTORIES << ["Menus", "app/menus"]
      ::STATS_DIRECTORIES << ["Presenters", "app/presenters"]
      ::STATS_DIRECTORIES << ["Proxies", "app/proxies"]
      ::STATS_DIRECTORIES << ["Services", "app/services"]
      ::STATS_DIRECTORIES << ["UseCases", "app/use_cases"]
    end
  end


  namespace :api do
    desc "API Routes"
    task :routes => [:environment] do
      DeployIt::API.routes.each do |api|
        method = api.route_method.ljust(10)
        path = api.route_path.gsub(":version", api.route_version)
        puts "     #{method} #{path}"
      end
    end
  end


  namespace :ci do
    begin
      require 'ci/reporter/rake/rspec'
      ENV["CI_REPORTS"] = Rails.root.join('junit').to_s
    rescue Exception => e
    end
    task :all => ['ci:setup:rspec', 'spec']
  end

end
