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

require 'open3'

module DeployIt
  module Utils
    module Exec
      extend self

      def capture(command, args = [], opts = {})
        output, err, code = execute(command, args, opts)
        if code != 0
          raise DeployIt::Error::IOError, "Non-zero exit code #{code} for `#{command} #{args.join(" ")}`"
        end
        output
      end


      def execute(command, args = [], opts = {})
        Open3.capture3(command, *args, opts)
      rescue => e
        raise DeployIt::Error::IOError, "Exception occured executing `#{command} #{args.join(" ")}` : #{e.message}"
      end

    end
  end
end
