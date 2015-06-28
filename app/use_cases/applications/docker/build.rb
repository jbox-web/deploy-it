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
    class Build < ActiveUseCase::Base

      attr_reader :log_to
      attr_reader :build_id
      attr_reader :request_id
      attr_reader :revision


      def execute(opts = {})
        # Set options
        set_options(opts)
        # Display banner
        welcome_banner
        # Call building chain
        receive
      end


      private


        # RECEIVE (create archive) --> BUILD --> RELEASE --> PUBLISH --> SCALE

        def receive
          # Create archive of repository
          result = application.distant_repo.create_archive!(revision)

          if !result.success?
            error_message("Erreurs lors de la réception des données de l'application '#{application.fullname}'")
            error_message(result.message_on_errors)
            error_message("You must push on origin repository first!")
          else
            build(result.path)
          end
        end


        def build(archive_path)
          # Display banner
          banner('Building application :')

          begin
            compiler = DockerServices::AppCompiler.new(application, archive_path, logger)
            compiler.run!
          rescue => e
            log_exception(e)
            error_message("Erreurs lors de la construction de l'application '#{application.fullname}'")
          else
            release
          end
        end


        def release
          # Display banner
          banner('Releasing application :')

          begin
            releaser = DockerServices::AppReleaser.new(application, build_id, logger)
            releaser.run!
          rescue => e
            log_exception(e)
            error_message("Erreurs lors de la création de la nouvelle version de l'application '#{application.fullname}'")
          else
            publish
          end
        end


        def publish
          # Display banner
          banner('Publishing application :')

          begin
            publisher = DockerServices::AppPublisher.new(application.image_tagged, logger)
            publisher.run!
          rescue => e
            log_exception(e)
            error_message("Erreurs lors de la publication de l'application '#{application.fullname}'")
          else
            scale
          end
        end


        def scale
          # Display banner
          banner('Scaling application :')

          begin
            scaler = DockerServices::AppScaler.new(application, logger)
            scaler.run!
          rescue => e
            log_exception(e)
            error_message("Erreurs lors du déploiement de l'application '#{application.fullname}'")
          else
            goodbye_banner
          end
        end


        def set_options(opts)
          @log_to     = opts[:logger]
          @build_id   = opts[:build_id]
          @request_id = opts[:request_id]
          @revision   = opts[:revision]
        end


        def welcome_banner
          logger.empty_line
          logger.padded("Welcome to JBox Deploy'it !")
        end


        def goodbye_banner
          logger.empty_line
          logger.header('Application deployed !')
          logger.empty_line
          logger.padded('Have a nice day!')
          logger.padded('The JBox Team @JBoxWeb.')
          logger.empty_line
        end


        def banner(message)
          logger.empty_line
          logger.header(message)
          logger.empty_line
        end


        def logger
          @logger ||=
            case log_to
            when 'file'
              DeployIt.file_logger
            when 'console'
              DeployIt.console_logger
            when 'console_streamer'
              DeployIt::Loggers::AsyncLogs.new(request_id)
            else
              DeployIt.file_logger
            end
        end

    end
  end
end
