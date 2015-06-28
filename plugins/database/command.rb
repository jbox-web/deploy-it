# DeployIt - Docker containers management software
# Copyright (C) 2015 Nicolas Rodriguez (nrodriguez@jbox-web.com), JBox Web (http://www.jbox-web.com)
#
# This code is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License, version 3,
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License, version 3,
# along with this program.  If not, see <http://www.gnu.org/licenses/>

module Database
  class Command < DockerServices::Plugins

    def pre_deploy
      run_task_runner
    end


    def run_task_runner
      return if !file_exists_in_container?('/app/Procfile')

      logger.title('Injecting Task Runner ...')
      copy_file_to_container(task_runner_path, '/build/task-runner', '755')

      logger.title('Running additionnal tasks ...')
      run_command('/build/task-runner', docker_options)
    end


    private


      # Local file to inject within the container to create/update database schema
      def task_runner_path
        File.join(File.dirname(__FILE__), 'files', 'task-runner.sh').to_s
      end

  end
end
