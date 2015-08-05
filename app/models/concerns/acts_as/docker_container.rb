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
  module DockerContainer
    extend ActiveSupport::Concern

    def state
      if running?
        :running
      elsif paused?
        :paused
      elsif stopped?
        :stopped
      end
    end


    def running?
      !!is_running? && !paused?
    end


    def paused?
      !!is_paused?
    end


    def stopped?
      !running? && !paused?
    end


    def docker_name
      docker_proxy.name
    end


    def docker_start
      docker_proxy.start
    end


    def docker_stop
      docker_proxy.stop
    end


    def docker_restart
      docker_proxy.restart
    end


    def docker_pause
      docker_proxy.pause
    end


    def docker_unpause
      docker_proxy.unpause
    end


    def docker_delete
      docker_proxy.delete
    end


    def docker_exec(command, opts = {}, &block)
      docker_proxy.exec(command, opts, &block)
    end


    def backend_port
      docker_proxy.backend_port(application.port)
    rescue => e
      nil
    end


    def backend_address
      docker_proxy.backend_address(application.port)
    rescue => e
      nil
    end


    def backend_url
      if !backend_address.nil? && !backend_port.nil?
        "#{backend_address}:#{backend_port}"
      else
        nil
      end
    end


    def uptime
      DateTime.parse(docker_proxy.uptime)
    end


    def info
      docker_proxy.info
    end


    def rename(new_name)
      docker_proxy.rename(new_name)
    end


    def docker_proxy
      @docker_proxy ||= DockerContainerProxy.new(docker_id, docker_server_proxy)
    end


    def docker_options
      { "Memory" => memory.megabytes.to_i, "CpuShares" => cpu_shares }
    end


    def docker_server_proxy
      docker_server.docker_proxy
    end


    private


      def is_running?
        return false if docker_server.nil?
        return false if docker_id.nil?
        docker_proxy.running? rescue false
      end


      def is_paused?
        return false if docker_server.nil?
        return false if docker_id.nil?
        docker_proxy.paused? rescue false
      end

  end
end
