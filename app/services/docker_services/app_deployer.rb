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

module DockerServices
  class AppDeployer

    include DockerHelper

    attr_reader :type
    attr_reader :application
    attr_reader :container
    attr_reader :hostname
    attr_reader :domain_name
    attr_reader :logger
    attr_reader :image
    attr_reader :docker_server


    def initialize(type, application, container, hostname, domain_name, logger)
      @type          = type
      @application   = application
      @container     = container
      @hostname      = hostname
      @domain_name   = domain_name
      @logger        = logger
      @image         = application.image_tagged
      @docker_server = container.docker_server_proxy
    end


    def run!
      if type == :web
        deploy(docker_options_for(:deploy))
      else
        deploy(docker_options_for(:cron))
      end
    end


    def deploy(docker_options = {})
      logger.padded("Pull Docker image '#{image}' from registry")
      begin
        docker_server.pull(image, Settings.docker_registry)
      rescue => e
        raise e
      else
        docker_options = docker_options.deep_merge("Hostname" => hostname, "Domainname" => domain_name)
        docker_options = docker_options.deep_merge(container_options)
        do_deploy(docker_options)
      end
    end


    def do_deploy(docker_options = {})
      begin
        # Create Docker container
        new_container = docker_server.create_container(docker_options)

        # Start it
        logger.padded("Starting new Docker '#{type}' container ...")
        new_container.start
      rescue => e
        raise e
      else
        logger.padded("Done !")

        # Get the new container ID and save it
        container.docker_id = new_container.id
        container.save!

        # Execute plugins
        execute_plugins(:post_deploy, docker_options) if type == :web
      end
    end


    def container_options
      {
        "HostConfig" => {
          "CpuShares"  => container.cpu_shares,
          "Memory"     => container.memory.megabytes,
          "MemorySwap" => -1
        }
      }
    end


    def docker_options_for(step)
      application.docker_options_for(step)
    end


    def execute_plugins(step, docker_options = {})
      Plugins.execute(step, application, docker_server, logger, docker_options)
    end

  end
end
