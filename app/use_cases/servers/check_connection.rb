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

module Servers
  class CheckConnection < ActiveUseCase::Base

    def execute(role)
      @role = role

      if @role.to_s == 'docker'
        docker_status
      else
        service_status
      end
    end


    private


      def docker_status
        begin
          server.docker_reachable?
        rescue => e
          @errors << treat_error(e.message)
        end
      end


      def service_status
        begin
          output = server.ssh_execute(@role.status_command)
        rescue => e
          @errors << treat_error(e.message)
        else
          # Output can be nil even if no error occurs (daemon is dead)
          @errors << I18n.t('label.server_role.offline', service: @role.humanize) if output.nil?
        end
      end


      def treat_error(error)
        "#{@role.humanize} : #{error}"
      end

  end
end
