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
      Hash[env_vars.collect { |env| [env.key, env.value] }].merge(additional_env_vars)
    end


    def sorted_env_vars
      Hash[env_vars.collect { |env| [env.key, env.value] }].merge(additional_env_vars)
    end


    def database_params
      params = {}
      params[:db_type] = database.db_type
      params[:db_host] = database.db_host
      params[:db_name] = database.db_name
      params[:db_user] = database.db_user
      params[:db_pass] = database.db_pass
      params[:db_socket] = database.db_socket
      params
    end


    private


      def additional_env_vars
        {
          buildpack_url:   buildpack,
          buildpack_debug: (debug_mode? ? 'true' : ''),
          site_dns:        domain_name,
          use_ssl:         use_ssl?,
          container_id:    identifier,
          port:            port,
          home:            '/app',
          log_server:      find_log_server
        }.merge(database_params)
      end


      def find_log_server
        find_server_with_role(:log).try(:logger_url) || ''
      end

  end
end
