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

module Helpers
  module Docker

    def file_exists_in_container?(file)
      docker_connection.file_exists?(application.image_name, file)
    end


    def directory_exists_in_container?(directory)
      docker_connection.directory_exists?(application.image_name, directory)
    end


    def run_command(command, docker_options = {})
      docker_connection.run_attached(application.image_name, command, docker_options) do |chunk|
        logger.info chunk
      end
    end


    def copy_file_to_container(source_file:, dest_file:, perms: '644', opts: {})
      docker_connection.inject_file(application.image_name, source_file, dest_file, perms, opts)
    end


    def new_image_from_file(image_source:, image_dest:, source_file:, dest_dir: , docker_options: {})
      docker_options = docker_options.merge(new_image_name: image_dest)
      docker_connection.inject_file(image_source, source_file, dest_dir, nil, { create_parent_dir: true, tar_file: true }, docker_options)
    end

  end
end
