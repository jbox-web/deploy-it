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
  module DockerApplication
    extend ActiveSupport::Concern

    def find_server_with_role(role)
      platform.first_server_available_with_role(role)
    end


    def data_path
      File.join(Settings.applications_datas_dir, deploy_url)
    end


    def build_cache_path
      File.join(data_path, 'build-cache')
    end


    def image_name
      "#{identifier}/#{stage_identifier}"
    end


    def tag
      "latest"
    end


    def image_tagged
      "#{image_name}:#{tag}"
    end


    def port
      '5000'
    end


    def start_command(type)
      [ '/bin/bash', '-c', "/start #{type}" ]
    end


    def state
      return :undeployed if containers.empty?
      if running?
        :running
      elsif paused?
        :paused
      elsif stopped?
        :stopped
      else
        :undefined
      end
    end


    def running?
      running_containers > 0
    end


    def paused?
      paused_containers == total_instance_number
    end


    def stopped?
      stopped_containers == total_instance_number
    end


    def backend_urls
      all_containers.type_web.map(&:docker_proxy).map(&:backend_url).compact
    end


    def running_containers
      proxified_containers.select { |c| c.running? }.size
    end


    def paused_containers
      proxified_containers.select { |c| c.paused? }.size
    end


    def stopped_containers
      proxified_containers.select { |c| c.stopped? }.size
    end


    def proxified_containers
      all_containers.map(&:docker_proxy)
    end


    def all_containers
      containers.includes(:docker_server)
    end


    def total_instance_number
      if use_cron?
        instance_number + 1
      else
        instance_number
      end
    end


    def mark_containers!(type:)
      scope = "type_#{type}"
      containers.send(scope).map(&:mark_for_deletion!)
    end


    def unmark_containers!(type:)
      scope = "type_#{type}"
      containers.send(scope).map(&:unmark_for_deletion!)
    end


    def create_container!(type:, release_id:)
      server  = find_server_with_role(:docker)
      options = {
        server_id:  server.id,
        release_id: release_id,
        image_type: get_image_type(type),
        memory:     get_container_memory(type),
        port:       get_container_port(type),
        type:       "Container::#{type.to_s.capitalize}"
      }
      containers.create(options)
    end


    def switch_containers!(type:, version:)
      delete_containers!(type: type)
      reload
      rename_containers!(type: type, version: version)
    end


    def application_container?(type)
      [:web, :cron, :data].include?(type)
    end


    def get_container_memory(type)
      return max_memory if application_container?(type)
      128
    end


    def get_image_type(type)
      return image_tagged if application_container?(type)
      addons.select { |a| a.type == type }.first.image
    end


    def get_container_port(type)
      return port if type == :web
      nil
    end


    def docker_options_for(step)
      case step
      when :receive, :build
        { "Env" => active_env_vars.to_env, "HostConfig" => { "Binds" => active_mount_points_with_path[step] } }
      else
        { "Env" => active_env_vars.to_env, "HostConfig" => { "Binds" => active_mount_points_with_path[:deploy] } }
      end
    end

  end
end
