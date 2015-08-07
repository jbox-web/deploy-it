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

require 'net/http'
require 'socket'

module Servers
  class CheckConnection < ActiveUseCase::Base

    def execute(role)
      @role = role
      case role.to_s
      when 'docker'
        check_docker
      when 'lb'
        check_http && check_ssh
      when 'pg_db', 'mysql_db'
        check_socket && check_ssh
      else
        check_socket
      end
    end


    private


      def check_docker
        catch_errors do
          server.docker_proxy.reachable?
        end
      end


      def check_http
        catch_errors do
          Net::HTTP.get(@role.host, '/')
        end
      end


      def check_socket
        catch_errors do
          TCPSocket.new(@role.host, @role.port)
        end
      end


      def check_ssh
        catch_errors do
          @output = server.ssh_proxy.execute('whoami')
        end
        @errors << I18n.t('label.server_role.offline', service: @role.humanize) if @output.nil?
      end


      def catch_errors(&block)
        begin
          yield
        rescue => e
          @errors << treat_error(e.message)
        end
      end


      def treat_error(error)
        "#{@role.humanize} : #{error}"
      end

  end
end
