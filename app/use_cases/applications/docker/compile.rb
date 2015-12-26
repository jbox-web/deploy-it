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
        builder_script:  ['/bin/herokuish', 'buildpack', 'build'],

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
      attr_reader :archive_path


      def execute(logger, archive_path)
        @logger       = logger
        @archive_path = archive_path

        cleanup
      end


      def cleanup
        logger.title tt('notice.on_cleanup')

        catch_error_or_next_method(:receive) do
          docker_connection.remove_stopped_containers_by_name(application.image_name)
        end
      end


      def receive(docker_options = {})
        # Push repository data within the container in tar format
        logger.title tt('notice.on_receive')

        be_sure = -> { FileUtils.rm(archive_path, force: true) unless archive_path.nil? }

        catch_error_or_next_method(:build, be_sure) do
          new_image_from_file(
            image_source:   application.image_type,
            image_dest:     application.image_name,
            source_file:    archive_path,
            dest_dir:       DEFAULT_SETTINGS[:app_dir],
            docker_options: docker_options
          )
        end
      end


      def build(docker_options = {})
        catch_error_or_next_method(:release) do
          # Inject BUILD_ENV file if exists
          install_build_vars

          # Execute plugins
          execute_plugins(:pre_build, docker_options)

          # Run BuildStep builder script
          run_command(builder_script, docker_options)

          # Execute plugins
          execute_plugins(:post_build, docker_options)
        end
      end


      def release(docker_options = {})
        catch_error_or_next_method do
          # Inject ENV file if exists
          install_app_vars

          # Inject DATABASE file if exists
          install_db_vars

          # Execute plugins
          execute_plugins(:pre_deploy, docker_options)
        end
      end


      private


        def install_build_vars
          install_var_file(:build) do
            logger.title tt('notice.on_build')
          end
        end


        def install_app_vars
          install_var_file(:deploy) do
            logger.title tt('notice.on_release.add_runtime_variables')
          end
        end


        def install_db_vars
          install_var_file(:database) do
            logger.title tt('notice.on_release.add_database_variables')
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


        def builder_script
          DockerImage.find_by_name(application.image_type).try(:builder_script) || DEFAULT_SETTINGS[:builder_script]
        end

    end
  end
end
