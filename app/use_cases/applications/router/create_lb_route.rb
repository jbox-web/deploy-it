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

      include Helpers::Ansible
      include Router::Base


      def execute(opts = {})
        execute_if_exists(router_server) do
          catch_errors(router_server) do
            router_server.ansible_proxy.run_playbook(playbook, extra_vars)
          end
        end
      end


      private


        def playbook
          Rails.root.join('lib', 'ansible_tasks', 'router', 'route-creator.yml').to_s
        end


        def extra_vars
          {
            application_name:  application.config_id,
            domain_name:       application.domain_name,
            domain_aliases:    application.domain_aliases.map(&:domain_name),
            domain_redirects:  application.domain_redirects.map(&:domain_name),
            use_ssl:           application.use_ssl?,
            enable_htpassword: application.use_credentials?,
            htpassword:        application.active_credentials,
            backend_urls:      backend_urls
          }
        end


        def backend_urls
          application.backend_urls.empty? ? default_backend : application.backend_urls
        end


        def default_backend
          ['127.0.0.1:20000']
        end

    end
  end
end
