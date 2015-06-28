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

module DockerServices
  class AppPublisher

    attr_reader :image_name
    attr_reader :logger


    def initialize(image_name, logger)
      @image_name = image_name
      @logger     = logger
    end


    def run!
      logger.title("Pushing Docker image '#{image_name}' to registry ...")
      docker_server.push(image_name, Settings.docker_registry)
      logger.padded("Done !")
    end


    def docker_server
      DockerServerProxy.local_server
    end

  end
end
