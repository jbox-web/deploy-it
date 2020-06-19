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
  module Docker
    class Release < ActiveUseCase::Base

      def execute(logger, build_id, author_id)
        logger.title("Creating new release ...")
        release = create_release(build_id, author_id)
        logger.padded("Release 'v#{release.version}' created !")
      end


      def create_release(build_id, author_id)
        config = application.configs.create(values: get_values)
        application.releases.create(build_id: build_id, author_id: author_id, config_id: config.id)
      end


      def get_values
        values = {}
        values[:env_vars]     = application.active_env_vars
        values[:mount_points] = application.active_mount_points_with_path
        values
      end

    end
  end
end
