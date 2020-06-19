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
  module HaveMountPoints
    extend ActiveSupport::Concern

    def active_mount_points
      get_mount_points(method: :to_s)
    end


    def active_mount_points_with_path
      get_mount_points(method: :full_path)
    end


    def sorted_mount_points
      receive = mounts_on(:receive).by_active
      build   = mounts_on(:build).by_active
      deploy  = mounts_on(:deploy).by_active
      { receive: receive, build: build, deploy: deploy }
    end


    private


      def get_mount_points(method: :to_s)
        receive = get_mount_point(:receive, method)
        build   = get_mount_point(:build, method)
        deploy  = get_mount_point(:deploy, method)
        { receive: receive, build: build, deploy: deploy }
      end


      def get_mount_point(mount_point, method)
        mounts_on(mount_point).active.map(&method)
      end


      ## User defined MountPoints
      def mounts_on(type)
        method = "on_#{type}"
        mount_points.send(method)
      end

  end
end
