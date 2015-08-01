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

module Applications
  module Files
    class UpdateFiles < ActiveUseCase::Base

      def execute
        update_file(application.env_file_for_build,  build_env_vars)
        update_file(application.env_file_for_deploy, deploy_env_vars)
        update_file(application.db_file,             database_env_vars)
      end


      private


        def update_file(file, content)
          File.delete(file) if File.exists?(file)
          begin
            new_file = File.open(file, 'w')
            new_file.write content + "\n"
            new_file.close
          rescue => e
            error_message('Error while creating Application config files!')
            log_exception(e)
          end
        end


        def build_env_vars
          application.active_env_vars.to_env.map { |var| "export #{var}" }.join("\n")
        end


        def deploy_env_vars
          application.active_env_vars.to_env.map { |var| "export #{var}" }.join("\n")
        end


        def database_env_vars
          application.database_params.to_env.map { |var| "export #{var}" }.join("\n")
        end

    end
  end
end
