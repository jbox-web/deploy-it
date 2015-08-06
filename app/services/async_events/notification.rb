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

    FONT_AWESOME_MAPPING = {
      success: 'fa-check',
      error:   'fa-exclamation',
      warning: 'fa-warning',
      info:    'fa-info-circle'
    }

    BOOTSTRAP_MAPPING = {
      success: 'success',
      error:   'danger',
      warning: 'warning',
      info:    'info'
    }

    include AsyncEvents::Base
    include ActionView::Helpers::TagHelper

    attr_reader :channels
    attr_reader :status
    attr_reader :event
    attr_reader :options


    def initialize(channels, status, options = {})
      @channels = channels
      @status   = status
      @event    = 'notification'
      @options  = options
    end


    class << self

      def success(channels, messages = [], opts = {})
        notify(channels, :success, messages, opts)
      end


      def error(channels, messages = [], opts = {})
        notify(channels, :error, messages, opts)
      end


      def warning(channels, messages = [], opts = {})
        notify(channels, :warning, messages, opts)
      end


      def info(channels, messages = [], opts = {})
        notify(channels, :info, messages, opts)
      end


      def notify(channels, status, messages = [], opts = {})
        new(channels, status, opts).send_messages!(messages)
      end

    end


    def send_messages!(message)
      messages = message.is_a?(String) ? [message] : message
      send_messages(messages)
    end


    private


      def send_messages(messages)
        messages.each do |message|
          send_async_notification!(channels, event, { title: title, message: message, icon: icon, type: type })
        end if channels.any?
      end


      def title
        options[:title] || ''
      end


      def icon
        icon = FONT_AWESOME_MAPPING[status] || options[:icon] || 'fa-info-circle'
        icon_default_class.push(icon).join(' ')
      end


      def type
        BOOTSTRAP_MAPPING[status] || options[:icon] || 'info'
      end


      def icon_default_class
        ['fa', 'fa-align']
      end

  end
end
