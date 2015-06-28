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
          params = {}

          if application_type.has_extra_attributes?
            # Convert JSON attributes to YAML
            attributes = YAML::load(application_type.extra_attributes.to_yaml)
            # Parse YAML
            if attributes.has_key?('env_vars')
              attributes['env_vars'].each do |step, vars|
                params[step.to_sym] = vars
              end
            end
          end

          params
        end


        def get_mount_points
          params = {}

          if application_type.has_extra_attributes?
            # Convert JSON attributes to YAML
            attributes = YAML::load(application_type.extra_attributes.to_yaml)
            # Parse YAML
            if attributes.has_key?('mount_points')
              attributes['mount_points'].each do |step, points|
                params[step.to_sym] = points
              end
            end
          end

          params
        end


        def get_secrets
          params = {}

          if application_type.has_extra_attributes?
            # Convert JSON attributes to YAML
            attributes = YAML::load(application_type.extra_attributes.to_yaml)
            # Parse YAML
            if attributes.has_key?('secrets')
              attributes['secrets'].each do |key, length|
                params[key.to_sym] = DeployIt::Utils.generate_secret(length)
              end
            end
          end

          params
        end


        def get_capacities
          { cpu: 1, memory: 256 }
        end


        def get_default_servers
          [ :docker, :log, :lb ].push(get_db_server_type)
        end


        def get_db_server_type
          application.db_type == 'mysql' ? :mysql_db : :pg_db
        end

    end
  end
end
