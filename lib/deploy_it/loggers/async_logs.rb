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
    class AsyncLogs

      include Loggers::CommonLogger

      attr_reader :request_id


      def initialize(request_id)
        @request_id = request_id
      end


      def write(log)
        log = log.gsub(/^\s*.+\[1G/, '')
        Danthes.publish_to "/console-streamer/#{request_id}", { event_type: 'console_stream', message: log }
      end

    end
  end
end
