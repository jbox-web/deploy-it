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

module ActsAs
  module DockerServer
    extend ActiveSupport::Concern

    def role_docker
      get_role_module('docker')
    end


    def docker_url
      "tcp://#{docker_host}:#{docker_port}"
    end


    def docker_host
      role_docker.host
    end


    def docker_port
      role_docker.port
    end


    def docker_reachable?
      docker_proxy.reachable?
    end


    def docker_proxy
      @docker_proxy ||= DockerServerProxy.new(docker_url, docker_options)
    end


    def docker_options
      { connect_timeout: connection_timeout, tcp_nodelay: true }
    end


    def connection_timeout
      role_docker.connection_timeout
    end

  end
end
