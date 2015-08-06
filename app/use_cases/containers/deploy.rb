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

module Containers
  class Deploy < ActiveUseCase::Base

    attr_reader :logger


    def execute(logger, hostname, domain_name)
      @logger = logger
      if image_updated?
        docker_options = docker_options_for(container.stype)
        docker_options = docker_options.deep_merge("Hostname" => hostname, "Domainname" => domain_name)
        docker_options = docker_options.deep_merge(container_options)
        deploy(docker_options)
      end
    end


    def image_updated?
      pull_image
    end


    def pull_image
      logger.padded("Pull Docker image '#{application.image_tagged}' from registry")
      begin
        docker_server.pull(application.image_tagged, Settings.docker_registry)
      rescue => e
        log_exception(e)
        error_message(e.message)
        false
      else
        true
      end
    end


    def deploy(docker_options = {})
      begin
        # Create Docker container
        new_container = docker_server.create_container(docker_options)

        # Start it
        logger.padded("Starting new Docker '#{container.stype}' container ...")
        new_container.start
      rescue => e
        log_exception(e)
        error_message(e.message)
      else
        logger.padded("Done !")

        # Get the new container ID and save it
        container.docker_id = new_container.id
        container.save!

        # Execute plugins
        execute_plugins(:post_deploy, docker_options) if container.stype == :web
      end
    end


    private


      def application
        container.application
      end


      def docker_server
        container.docker_server_proxy
      end


      def docker_options_for(step)
        application.docker_options_for(step)
      end


      def execute_plugins(step, docker_options = {})
        DockerPlugin.execute(step, application, docker_server, logger, docker_options)
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

  end
end
