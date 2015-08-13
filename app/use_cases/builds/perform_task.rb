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

module Builds
  class PerformTask < ActiveUseCase::Base

    def execute(opts = {})
      # Get event options
      event_options = opts.delete(:event_options){ {} }

      # Build task options
      task_options  = set_options(opts)

      # Build people_to_notify list
      channels = application.notification_channels

      # Get UseCase
      use_case = application.find_active_use_case('build')

      # Send job start notification
      AsyncEvents::Notification.info(channels, use_case.message_on_start)

      # Perform job
      result = use_case.call(task_options)

      if result.success?
        # Update state machine
        build.finish!
        # Send job end notification
        AsyncEvents::Notification.success(channels, result.message_on_success)
      else
        # Follow up errors from use case
        @errors.concat(result.errors)
        # Update state machine
        build.fail!
        # Send job end notification
        AsyncEvents::Notification.error(channels, result.message_on_errors)
      end

      AsyncEvents::ViewRefresh.call(channels, event_options)
    end


    private


      def application
        build.application
      end


      def set_options(opts)
        options = opts.symbolize_keys
        options = options.merge(build_id:   build.id)
        options = options.merge(author_id:  build.author_id)
        options = options.merge(request_id: build.request_id)
        options = options.merge(revision:   build.push.new_revision)
        options
      end

  end
end
