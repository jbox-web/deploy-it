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

module DockerApplication
  module HaveDefaultParams
    extend ActiveSupport::Concern

    def get_default_params_for(type)
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
