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
  module Router
    class CreateLbRoute < ActiveUseCase::Base

      def execute
        begin
          router_server.recreate_inventory_file!
          router_server.ansible_proxy.run_playbook(route_creator, extra_vars)
        rescue => e
          error_message("Error while notifying router")
          log_exception(e)
        end
      end


      private


        def router_server
          application.find_server_with_role(:lb)
        end


        def route_creator
          Rails.root.join('lib', 'ansible_tasks', 'router', 'route-creator.yml').to_s
        end


        def backend_urls
          application.backend_urls.empty? ? default_backend : application.backend_urls
        end


        def default_backend
          ['127.0.0.1:20000']
        end


        def extra_vars
          {
            application_name: application.config_id,
            backend_urls: backend_urls,
            domain_name: application.domain_name,
            domain_aliases: application.domain_aliases.map(&:domain_name),
            domain_redirects: application.domain_redirects.map(&:domain_name),
            use_ssl: application.use_ssl?
          }
        end

    end
  end
end
