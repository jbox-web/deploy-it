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

module AsyncEvents
  class ViewRefresh

    include AsyncEvents::Base

    attr_reader :channels
    attr_reader :event


    def initialize(channels)
      @channels = channels
      @event    = 'view_refresh'
    end


    class << self

      def call(channels, opts = {})
        new(channels).refresh_view!(opts)
      end

    end


    def refresh_view!(opts = {})
      send_async_notification!(channels, event, opts) if channels.any? && !opts.empty?
    end

  end
end
