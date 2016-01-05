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
      5000
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
      total = instance_number
      total += addons.count
      total += 1 if use_cron?
      total
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
        image_name: get_image_name(type),
        memory:     get_container_memory(type),
        port:       get_container_port(type),
        type:       type
      }
      containers.create(options)
    end


    def switch_containers!(type:, version:)
      delete_containers!(type: type)
      reload
      rename_containers!(type: type, version: version)
    end


    def application_container?(type)
      self.class.application_containers.include?(type)
    end


    def application_addon?(type)
      self.class.addons_available.include?(type)
    end


    def get_container_memory(type)
      return max_memory if application_container?(type)
      128
    end


    def get_image_name(type)
      return image_tagged if application_container?(type)
      addons.select { |a| a.type == type }.first.image_name
    end


    def get_container_port(type)
      return port if type == 'web'
      return addons.select { |a| a.type == type }.first.port if application_addon?(type)
      nil
    end


    def docker_options_for(step)
      case step
      when :receive, :build
        { "Env" => active_env_vars.merge(current_step: step).to_env, "HostConfig" => { "Binds" => active_mount_points_with_path[step] } }
      when :deploy
        get_linked_containers.deep_merge({ "Env" => active_env_vars.merge(current_step: step).to_env, "HostConfig" => { "Binds" => active_mount_points_with_path[:deploy] } })
      else
        { "Env" => active_env_vars.merge(current_step: step).to_env, "HostConfig" => { "Binds" => active_mount_points_with_path[:deploy] } }
      end
    end


    def get_linked_containers
      return {} if linked_containers.empty?
      { "HostConfig" => { "Links": linked_containers } }
    end


    def linked_containers
      linked_containers = []
      DeployIt.addons_available.each do |a|
        linked_containers += containers.send("type_#{a}").map { |c| "#{c.docker_id}:#{a}" }
      end
      linked_containers
    end

  end
end
