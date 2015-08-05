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
  module Database
    class DestroyPhysicalDatabase < ActiveUseCase::Base

      def execute(opts = {})
        begin
          database_server.recreate_inventory_file!
          database_server.ansible_proxy.run_playbook(database_destroyer, extra_vars)
        rescue => e
          error_message("Error while destroying '#{application.database.db_type}' database")
          log_exception(e)
        end
      end


      private


        def database_server
          application.database.server
        end


        def database_destroyer
          application.database.db_type == 'mysql' ? mysql_database_destroyer : postgres_database_destroyer
        end


        # Local file to create database on distant server with Ansible
        def mysql_database_destroyer
          Rails.root.join('lib', 'ansible_tasks', 'database', 'mysql-database-destroyer.yml').to_s
        end


        def postgres_database_destroyer
          Rails.root.join('lib', 'ansible_tasks', 'database', 'postgres-database-destroyer.yml').to_s
        end


        def extra_vars
          { db_name: application.database.db_name, db_user: application.database.db_user }
        end

    end
  end
end
