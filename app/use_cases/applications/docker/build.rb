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
      attr_reader :author_id
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


        # RECEIVE (create archive) --> COMPILE --> RELEASE --> PUBLISH --> SCALE

        def receive
          logger.banner tt('notice.on_receive')
          result = application.distant_repo.create_archive!(revision)
          if result.success?
            logger.padded('Done !')
            compile(result.path)
          else
            error_message tt('errors.on_receive', errors: result.errors.to_sentence)
            error_message tt('warning.on_receive')
          end
        end


        def compile(archive_path)
          logger.banner tt('notice.on_compile')
          result = application.compile!(logger, archive_path)
          if result.success?
            release
          else
            error_message tt('errors.on_compile', errors: result.errors.to_sentence)
          end
        end


        def release
          logger.banner tt('notice.on_release')
          result = application.release!(logger, build_id, author_id)
          if result.success?
            publish
          else
            error_message tt('errors.on_release', errors: result.errors.to_sentence)
          end
        end


        def publish
          logger.banner tt('notice.on_publish')
          result = application.publish!(logger)
          if result.success?
            scale
          else
            error_message tt('errors.on_publish', errors: result.errors.to_sentence)
          end
        end


        def scale
          logger.banner tt('notice.on_scale')
          result = application.scale!(logger)
          if result.success?
            goodbye_banner
          else
            error_message tt('errors.on_scale', errors: result.errors.to_sentence)
          end
        end


        def set_options(opts)
          @log_to     = opts[:logger]
          @build_id   = opts[:build_id]
          @author_id  = opts[:author_id]
          @request_id = opts[:request_id]
          @revision   = opts[:revision]
        end


        def welcome_banner
          logger.empty_line
          logger.padded(tt('notice.welcome'))
        end


        def goodbye_banner
          logger.banner(tt('notice.application_deployed'))
          logger.padded(tt('notice.goodbye'))
          logger.padded(tt('notice.signature'))
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
