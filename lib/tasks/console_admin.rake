namespace :deploy_it do
  namespace :console_admin do

    desc 'Restart all Containers'
    task :restart_containers => [:environment] do
      User.current = User.find_by_login('admin')

      Container.all.each do |container|
        puts "Restarting : #{container.identifier}"
        # Create Deployment Request
        request = Deployments::RequestBuilder.new(container, User.current, 'start').build

        # Call the TaskManager
        task = Deployments::TaskManager.new(request, async: true, logger: 'console')
        if task.runnable?
          task.run!
          if !task.success?
            DeployIt::Utils.display_errors_on_console(task.errors)
          end
        else
          DeployIt::Utils.display_errors_on_console(task.errors)
        end
      end
    end

  end
end
