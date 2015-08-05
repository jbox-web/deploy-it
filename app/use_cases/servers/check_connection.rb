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
        check_http
      else
        check_socket
      end
    end


    private


      def check_docker
        catch_errors do
          server.docker_reachable?
        end
      end


      def check_http
        catch_errors do
          Net::HTTP.get(host, '/')
        end
      end


      def check_socket
        catch_errors do
          TCPSocket.new(host, @role.port)
        end
      end


      def host
        (@role.alternative_host.nil? || @role.alternative_host.empty?) ? server.ip_address : @role.alternative_host
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
