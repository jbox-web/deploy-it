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
      base_params.merge(Hash[env_vars.collect { |env| [env.key, env.value] }])
    end


    def base_params
      application_params.merge(database_params)
    end


    def database_params
      params = {}
      params[:db_type]   = database.db_type
      params[:db_host]   = db_host
      params[:db_port]   = database.db_port
      params[:db_name]   = database.db_name
      params[:db_user]   = database.db_user
      params[:db_pass]   = database.db_pass
      params[:db_socket] = database.db_socket
      params
    end


    def application_params
      params = {}
      params[:buildpack_url]   = buildpack
      params[:buildpack_debug] = debug_mode? ? 'true' : ''
      params[:site_dns]        = domain_name
      params[:use_ssl]         = use_ssl?
      params[:port]            = port
      params[:home]            = '/app'
      params[:log_server]      = find_log_server
      params[:secret_key_base] = DeployIt::Utils::Crypto.generate_secret(64)
      params
    end


    private


      def find_log_server
        find_server_with_role(:log).try(:logger_url) || ''
      end


      def db_host
        if database.db_host == '127.0.0.1' && application_type.name.downcase == 'joomla'
          "localhost:#{database.db_socket}"
        else
          database.db_host
        end
      end

  end
end
