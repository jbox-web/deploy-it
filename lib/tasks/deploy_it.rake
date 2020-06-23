namespace :deploy_it do

  desc "Show Deploy'It version"
  task :version do
    puts "Deploy'It 1.0.0"
  end


  namespace :applications do
    desc "Rebuild all applications"
    task rebuild_all: [:environment] do
      user = User.find_by_id(1)

      Application.find_each do |application|
        puts application.config_id

        # First create push
        push = application.pushes.last

        # Then build application
        ApplicationManagementContext.new(DeployIt::Utils::Console).build_application(application, user, push, async: false, logger: 'console') do |task|
          DeployIt::Utils::Console.render_failed(message: task.errors) if !task.success?
        end
      end
    end

    desc "Dump applications repo config to YAML"
    task dump_repo_config: [:environment] do
      configs = {}

      Application.find_each do |application|
        configs[application.identifier] = { 'git_url' => application.distant_repo.git_url, 'deploy_it_url' => application.local_repo.git_url }
      end

      puts YAML.dump(configs)
    end
  end
end
