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
    class CreatePhysicalDatabase < ActiveUseCase::Base

      def execute
        begin
          database_server.recreate_inventory_file!
          database_server.ansible_proxy.run_playbook(database_creator, extra_vars)
        rescue => e
          error_message("Error while creating '#{application.database.db_type}' database")
          log_exception(e)
        else
          application.database.update_attribute(:db_created, true)
        end
      end


      private


        def database_server
          application.database.server
        end


        def database_creator
          application.database.db_type == 'mysql' ? mysql_database_creator : postgres_database_creator
        end


        # Local file to create database on distant server with Ansible
        def mysql_database_creator
          Rails.root.join('lib', 'ansible_tasks', 'database', 'mysql-database-creator.yml').to_s
        end


        def postgres_database_creator
          Rails.root.join('lib', 'ansible_tasks', 'database', 'postgres-database-creator.yml').to_s
        end


        def extra_vars
          { db_name: application.database.db_name, db_user: application.database.db_user, db_pass: application.database.db_pass }
        end

    end
  end
end
