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
    class RestoreEnvVars < ActiveUseCase::Base

      def execute
        get_env_vars_list.each do |step, env_vars|
          env_vars.each do |key, value|
            ev_db = application.env_vars.find_by_key_and_step(key, step)
            if ev_db.nil?
              application.env_vars.create(key: key, value: value, step: step.to_s)
            end
          end
        end

        get_secrets_list.each do |key, value|
          ev_db = application.env_vars.find_by_key_and_step(key, 'deploy')
          if ev_db.nil?
            application.env_vars.create(key: key, value: value, step: 'deploy', protected: true)
          end
        end
      end


      def get_env_vars_list
        application.get_default_params!(:env_vars)
      end


      def get_secrets_list
        application.get_default_params!(:secrets)
      end

    end
  end
end
