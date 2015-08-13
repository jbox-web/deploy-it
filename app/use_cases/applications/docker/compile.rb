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

require 'fileutils'

module Applications
  module Docker
    class Compile < ActiveUseCase::Base

      DEFAULT_SETTINGS = {
        # The directory within the container which will contain our app
        app_dir:         '/app',

        # The script to run to build our app
        builder_script:  '/build/builder',

        ## Environment variables files

        # on build :
        build: {
          dest_file: '/app/.env'
        },

        # on deploy :
        deploy: {
          dest_file: '/app/.profile.d/app-env.sh',
          opts:      { create_parent_dir: true }
        },

        # for database :
        database: {
          dest_file: '/app/.profile.d/db-env.sh',
          opts:      { create_parent_dir: true },
          perms:     '640'
        }
      }


      include Helpers::Docker

      attr_reader :logger


      def execute(logger, archive_path)
        @logger = logger

        cleanup(application.image_name)
        receive(archive_path, docker_options_for(:receive))
      end


      def cleanup(image)
        logger.title 'Cleaning up the room'
        docker_connection.remove_stopped_containers_by_name(image)
      end


      def receive(archive_path, docker_options = {})
        # Push repository data within the container in tar format
        logger.title 'Creating a new Docker image with your application'
        begin
          new_image_from_file(
            image_source:   application.image_type,
            image_dest:     application.image_name,
            source_file:    archive_path,
            dest_dir:       DEFAULT_SETTINGS[:app_dir],
            docker_options: docker_options
          )
        rescue ::Docker::Error::TimeoutError => e
          error_message tt('errors.on_receive.docker_timeout')
        else
          build(docker_options_for(:build))
          release(docker_options_for(:release))
        ensure
          # Remove repository data
          FileUtils.rm(archive_path, force: true) unless archive_path.nil?
        end
      end


      def build(docker_options = {})
        # Inject BUILD_ENV file if exists
        install_build_vars

        # Execute plugins
        execute_plugins(:pre_build, docker_options)

        # Run BuildStep builder script
        run_command(DEFAULT_SETTINGS[:builder_script], docker_options)

        # Execute plugins
        execute_plugins(:post_build, docker_options)
      end


      def release(docker_options = {})
        # Inject ENV file if exists
        install_app_vars

        # Inject DATABASE file if exists
        install_db_vars

        # Execute plugins
        execute_plugins(:pre_deploy, docker_options)
      end


      private


        def install_build_vars
          install_var_file(:build) do
            logger.title "Adding environment variables to build environment"
          end
        end


        def install_app_vars
          install_var_file(:deploy) do
            logger.title "Adding environment variables to runtime environment"
          end
        end


        def install_db_vars
          install_var_file(:database) do
            logger.title 'Pushing database variables within the container'
          end
        end


        def install_var_file(step, &block)
          if application.env_file_available_for?(step)
            yield
            copy_file_to_container source_file: application.env_file_for(step), **DEFAULT_SETTINGS[step]
          end
        end


        def docker_connection
          DockerServerProxy.local_server
        end


        def docker_options_for(step)
          application.docker_options_for(step)
        end


        def execute_plugins(step, docker_options = {})
          DockerPlugin.execute(step, application, docker_connection, logger, docker_options)
        end

    end
  end
end
