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

module Applications
  module Params
    class RestoreEnvVars < ActiveUseCase::Base

      def execute(opts = {})
        restore_env_vars('env_vars')
        restore_env_vars('secrets', masked: true)
      end


      def restore_env_vars(type, masked: false)
        application.get_default_params_for(type).each do |key, value|
          ev_db = application.env_vars.find_by_key(key)
          application.env_vars.create(key: key, value: value, masked: masked) if ev_db.nil?
        end
      end

    end
  end
end
