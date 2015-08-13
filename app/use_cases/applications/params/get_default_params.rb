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

module Applications
  module Params
    class GetDefaultParams

      attr_reader :application
      attr_reader :application_type


      def initialize(application)
        @application      = application
        @application_type = application.application_type
      end


      def call(params_type)
        method = "get_#{params_type}"
        self.send(method)
      end


      private


        def get_env_vars
          extract_params('env_vars')
        end


        def get_mount_points
          extract_params('mount_points')
        end


        def get_secrets
          extract_params('secrets')
        end


        def get_capacities
          { cpu: 1, memory: 256 }
        end


        def get_default_servers
          [:docker, :log, :lb].push(get_db_server_type)
        end


        def get_db_server_type
          application.db_type == 'mysql' ? :mysql_db : :pg_db
        end


        def extract_params(type)
          params = {}

          if application_type.has_extra_attributes?
            # Convert JSON attributes to YAML
            attributes = YAML::load(application_type.extra_attributes.to_yaml)
            # Parse YAML
            if attributes.has_key?(type)
              attributes[type].each do |key, value|
                if type == 'secrets'
                  params[key.to_sym] = DeployIt::Utils::Crypto.generate_secret(value)
                else
                  params[key.to_sym] = value
                end
              end
            end
          end

          params
        end

    end
  end
end
