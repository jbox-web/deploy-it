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

module DockerApplication
  module HaveEnvVars
    extend ActiveSupport::Concern

    def active_env_vars
      { receive: env_vars_on_receive, build: env_vars_on_build, deploy: env_vars_on_deploy }
    end


    def sorted_env_vars
      { receive: env_vars.on_receive, build: env_vars.on_build, deploy: env_vars.on_deploy }
    end


    def env_vars_on_receive
      env_vars_on(:receive).merge(additional_env_vars_on(:receive))
    end


    def env_vars_on_build
      env_vars_on(:build).merge(additional_env_vars_on(:build))
    end


    def env_vars_on_deploy
      env_vars_on(:deploy).merge(additional_env_vars_on(:deploy))
    end


    def database_params
      params = {}
      params[:db_type] = database.db_type
      params[:db_host] = database.db_host
      params[:db_name] = database.db_name
      params[:db_user] = database.db_user
      params[:db_pass] = database.db_pass
      params
    end


    private


      ## User defined EnvVars
      def env_vars_on(type)
        case type
        when :receive
          Hash[env_vars.on_receive.collect { |env| [env.key, env.value] }]
        when :build
          Hash[env_vars.on_build.collect { |env| [env.key, env.value] }]
        when :deploy
          Hash[env_vars.on_deploy.collect { |env| [env.key, env.value] }]
        end
      end


      def additional_env_vars_on(type)
        case type
        when :receive
          {}
        when :build
          { buildpack_url: buildpack, buildpack_debug: (debug_mode? ? 'true' : '') }
        when :deploy
          { site_dns: domain_name, use_ssl: use_ssl?, container_id: identifier, port: port, log_server: find_log_server }
        end
      end


      def find_log_server
        find_server_with_role(:log).try(:logger_url) || ''
      end

  end
end
