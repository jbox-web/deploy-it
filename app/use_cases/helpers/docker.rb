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

module Helpers
  module Docker

    def file_exists_in_container?(file)
      docker_connection.file_exists?(application.image_name, file)
    end


    def directory_exists_in_container?(directory)
      docker_connection.directory_exists?(application.image_name, directory)
    end


    def run_command(command, docker_options = {})
      success = docker_connection.run_attached(application.image_name, command, docker_options) do |chunk|
        logger.info chunk
      end
      success
    end


    def copy_file_to_container(source_file:, dest_file:, perms: '644', opts: {})
      docker_connection.inject_file(
        image_name:  application.image_name,
        source_file: source_file,
        dest_file:   dest_file,
        perms:       perms,
        opts:        opts
      )
    end


    def new_image_from_file(image_source:, image_dest:, source_file:, dest_dir:, docker_options: {})
      docker_connection.inject_file(
        image_name:     image_source,
        source_file:    source_file,
        dest_file:      dest_dir,
        opts:           { create_parent_dir: true, from_tar_file: true },
        docker_options: docker_options.merge(new_image_name: image_dest)
      )
    end


    def catch_error_or_next_method(method = nil, be_sure = nil, &block)
      begin
        yield
      rescue ::Docker::Error::TimeoutError
        error_message I18n.t('errors.docker.timeout')
      rescue ::Docker::Error::NotFoundError
        error_message I18n.t('errors.docker.image_not_found', image: application.image_type)
      rescue EOFError, Excon::Errors::SocketError
        error_message I18n.t('errors.docker.connection_refused')
      rescue DeployIt::Error::CompilationFailed
        error_message I18n.t('errors.deploy_it.compilation_failed')
      rescue => e
        error_message I18n.t('errors.docker.unknown_error', error: e.message)
      else
        self.send(method, docker_options_for(method)) if method
      ensure
        be_sure.call if be_sure
      end
    end

  end
end
