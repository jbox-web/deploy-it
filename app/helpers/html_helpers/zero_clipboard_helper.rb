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

module HtmlHelpers
  module ZeroClipboardHelper

    def zero_clipboard_button_for(target)
      render_zero_clipboard_button(target) + render_zero_clipboard_javascript(target)
    end


    private


      def render_zero_clipboard_button(target)
        content_tag(:div, id: "zc_#{target}", style: 'float: left;', data: zero_clipboard_options.merge('clipboard-target' => target)) do
          image_tag('paste.png')
        end
      end


      def render_zero_clipboard_javascript(target)
        javascript_tag("setZeroClipBoard('#zc_#{target}');")
      end


      def zero_clipboard_options
        { 'label-copied'  => t('text.copied'), 'label-to-copy' => t('text.copy_to_clipboard') }
      end

  end
end
