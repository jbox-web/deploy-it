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
    class Publish < ActiveUseCase::Base

      def execute(logger)
        logger.title("Pushing Docker image '#{application.image_tagged}' to registry ...")
        begin
          docker_server.push(application.image_tagged, Settings.docker_registry)
        rescue => e
          log_exception(e)
          error_message(e.message)
        else
          logger.padded("Done !")
        end
      end


      def docker_server
        DockerServerProxy.local_server
      end

    end
  end
end
