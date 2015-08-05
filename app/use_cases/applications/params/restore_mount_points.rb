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
    class RestoreMountPoints < ActiveUseCase::Base

      def execute(opts = {})
        get_mount_points_list.each do |step, mount_points|
          mount_points.each do |source, target|
            mp_db = application.mount_points.find_by_source_and_step(source, step)
            if mp_db.nil?
              application.mount_points.create(source: source, target: target, step: step.to_s)
            end
          end
        end
      end


      def get_mount_points_list
        application.get_default_params!(:mount_points)
      end

    end
  end
end
