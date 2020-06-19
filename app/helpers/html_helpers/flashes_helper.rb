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
  module FlashesHelper

    def render_flash_messages
      content = FlashMessagePresenter.render_flash_messages(self, flash)
      flash.discard
      content
    end


    def render_flash_messages_as_js(target = '#flash-messages', opts = {})
      str = js_render(target, render_flash_messages, opts)
      str << "setAlertDismiss();\n"
      str.html_safe
    end

  end
end
