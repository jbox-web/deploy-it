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
  module Params
    class CreateRelations < ActiveUseCase::Base

      def execute
        create_member_record
        create_distant_repository_record
        create_local_repository_record
        create_application_database_record
        create_config_records
      end


      private


        def create_member_record
          role = Role.givable.first
          member = Member.new(enrolable: User.current, roles: [role])
          application.members << member
        end


        # Create repository record in database (from virtual attributes)
        def create_distant_repository_record
          repository_path = "#{application.identifier}.git"
          application.create_distant_repo(url: application.repository_url, branch: application.repository_branch, relative_path: repository_path)
        end


        def create_local_repository_record
          repository_path = "#{application.deploy_url}.git"
          application.create_local_repo(url: repository_path, relative_path: repository_path)
        end


        # Write virtual attributes in database
        def create_application_database_record
          application.create_database({
            server_id: application.find_server_with_role(get_db_type).try(:id),
            db_type:   application.temp_db_type,
            db_name:   application.temp_db_name,
            db_user:   application.temp_db_user,
            db_pass:   application.temp_db_pass
          })
        end


        def get_db_type
          if application.temp_db_type == 'mysql'
            :mysql_db
          else
            :pg_db
          end
        end


        def create_config_records
          # Create associated MountPoints in database
          application.restore_mount_points!

          # Create associated EnvVars in database
          application.restore_env_vars!
        end

    end
  end
end
