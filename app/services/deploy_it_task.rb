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

module DeployItTask
  extend self

  def perform(object, method, opts = {}, &block)
    async_view_refresh = opts.delete(:async_view_refresh){ {} }

    # Build people_to_notify list
    channels = object.notification_channels

    # Get UseCase
    use_case = object.find_active_use_case(method)

    # Send job start notification
    AsyncEvents::Notification.info(channels, use_case.message_on_start)

    # Perform job
    result = use_case.call(opts)

    yield result if block_given?

    # Send job end notification
    if result.success?
      AsyncEvents::Notification.success(channels, result.message_on_success)
    else
      AsyncEvents::Notification.error(channels, result.message_on_errors)
    end

    AsyncEvents::ViewRefresh.call(channels, async_view_refresh)
  end

end
