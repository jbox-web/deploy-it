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
    class DestroyLbRoute < ActiveUseCase::Base

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
          Rails.root.join('lib', 'ansible_tasks', 'router', 'route-destroyer.yml').to_s
        end


        def extra_vars
          { application_name: application.config_id }
        end

    end
  end
end
