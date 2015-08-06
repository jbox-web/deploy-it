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

class FlashMessagePresenter < SimpleDelegator

  attr_reader :type
  attr_reader :message


  def initialize(view, type, message)
    super(view)
    @type    = type
    @message = message
  end


  class << self

    def render_flash_messages(view, flashes)
      flashes.map{ |type, message|
        if message.is_a?(String)
          FlashMessagePresenter.new(view, type, message).to_s
        else
          message.collect { |msg| FlashMessagePresenter.new(view, type, msg).to_s }
        end
      }.join('').html_safe
    end

  end


  def to_s
    render_flash_message
  end


  private


    def render_flash_message
      flash_container do
        close_button +
        formated_message.html_safe
      end
    end


    def flash_container(&block)
      content_tag(:div, class: css_classes, role: 'alert') do
        yield block
      end
    end


    def formated_message
      content_tag(:p) do
        label_with_icon(message, icon)
      end
    end


    def icon
      DeployIt::Theme::FONT_AWESOME_MAPPING[type.to_sym]
    end


    def css_classes
      default_css_classes.clone.push(flash_css_class)
    end


    def flash_css_class
      DeployIt::Theme::BOOTSTRAP_ALERT_MAPPING[type.to_sym]
    end


    def default_css_classes
      DeployIt::Theme::BOOTSTRAP_ALERT_DEFAULT_CLASS
    end


    def close_button
      content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
        content_tag(:span, '&times;'.html_safe, 'aria-hidden' => 'true') +
        content_tag(:span, 'Close', class: 'sr-only')
      end
    end

end
