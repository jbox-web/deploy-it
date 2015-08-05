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

module DeployIt
  module Loggers
    module CommonLogger

      def empty_line
        info('')
      end


      def title(message)
        info(message, type: :title)
      end


      def header(message)
        info(message, type: :header)
      end


      def padded(message)
        info(message, type: :padded)
      end


      def debug(log, opts = {})
        write "[DEBUG] #{log}" if Settings.log_level == 'debug'
      end


      def info(log, opts = {})
        case opts[:type]
        when :header
          write "=====> #{log}"
        when :title
          write "-----> #{log}"
        when :padded
          write "       #{log}"
        else
          write "#{log}"
        end
      end


      def warn(log, opts = {})
        write "[WARNING] #{log}"
      end


      def error(log, padding = false)
        if padding
          write "[ERROR]       #{log}"
        else
          write "[ERROR] #{log}"
        end
      end

    end
  end
end
