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

require 'open3'

module DeployIt
  module Utils
    module Exec
      extend self

      def capture(command, args = [])
        output, err, code = execute(command, args)
        if code != 0
          error_msg = "Non-zero exit code #{code} for `#{command} #{args.join(" ")}`"
          DeployIt.file_logger.error error_msg
          raise DeployIt::Error::IOError
        end
        output
      end


      def execute(command, args = [])
        Open3.capture3(command, *args)
      rescue => e
        error_msg = "Exception occured executing `#{command} #{args.join(" ")}` : #{e.message}"
        DeployIt.file_logger.error error_msg
        raise DeployIt::Error::IOError
      end

    end
  end
end
