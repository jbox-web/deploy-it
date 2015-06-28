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
  class Notification

    include AsyncEvents::Base
    include ActionView::Helpers::TagHelper

    attr_reader :channels
    attr_reader :status
    attr_reader :event


    def initialize(channels, status, options = {})
      @channels = channels
      @status   = status
      @event    = 'notification'
    end


    class << self

      def info(channels, message, opts = {})
        notify(channels, :info, message, opts)
      end


      def success(channels, message, opts = {})
        notify(channels, :success, message, opts)
      end


      def errors(channels, message, opts = {})
        notify(channels, :error, message, opts)
      end


      def notify(channels, status, message, opts = {})
        new(channels, status, opts).send_messages!(message)
      end

    end


    def send_messages!(message)
      messages = message.is_a?(String) ? [message] : message
      send_messages(messages)
    end


    private


      def send_messages(messages)
        messages.each do |message|
          send_async_notification!(channels, event, { title: title, message: message, icon: icon, type: type }) if channels.any?
        end
      end


      def title
        ''
      end


      def icon
        message_icon =
          case status
          when :success
            'fa-check'
          when :error
            'fa-exclamation'
          when :warning
            'fa-warning'
          when :info
            'fa-info-circle'
          else
            'fa-info-circle'
          end
        "fa fa-align #{message_icon}"
      end


      def type
        case status
        when :success
          'success'
        when :error
          'danger'
        when :warning
          'warning'
        when :info
          'info'
        else
          'info'
        end
      end

  end
end
