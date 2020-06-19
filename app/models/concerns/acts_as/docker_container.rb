# frozen_string_literal: true
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

    APPLICATION_CONTAINERS    = %w(data clock web worker)
    ADDONS_CONTAINERS         = DeployIt.addons_available
    CONTAINER_TYPES_AVAILABLE = APPLICATION_CONTAINERS + ADDONS_CONTAINERS

    included do
      CONTAINER_TYPES_AVAILABLE.each do |c|
        define_method :"#{c}?" do
          type == c
        end
      end
    end


    def docker_proxy
      @docker_proxy ||= DockerContainerProxy.new(self)
    end


    def docker_name
      docker_proxy.name
    end


    def docker_options
      options = docker_base_options
      options = options.deep_merge(docker_port_options) unless port.nil?
      options
    end


    def docker_base_options
      {
        "Cmd"   => start_command,
        "Image" => image_name,
        "HostConfig" => {
          "CpuShares"  => cpu_shares,
          "Memory"     => memory.megabytes,
          "MemorySwap" => -1
        }
      }
    end


    def docker_port_options
      {
        "ExposedPorts" => {
          "#{port}/tcp" => {}
        },
        "HostConfig" => {
          "PortBindings" => {
            "#{port}/tcp" => [{
              "HostIp" => "127.0.0.1"
            }]
          }
        }
      }
    end


    def addon_container?
      ADDONS_CONTAINERS.include?(type)
    end


    def application_container?
      APPLICATION_CONTAINERS.include?(type)
    end


    def start_command
      return ['/bin/bash', '-c', "/start #{type}"] if application_container?
      return DeployIt.addons[stype][:start_command] if addon_container?
      []
    end


    def docker_registry
      return Settings.docker_registry if application_container?
      return DeployIt.addons[stype][:docker_registry] if addon_container?
      nil
    end

  end
end
