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

module Admin
  module ApplicationsHelper

    def render_application_state(state)
      case state
      when :running
        label_with_success_tag(state)
      when :stopped
        label_with_danger_tag(state)
      when :paused
        label_with_warning_tag(state)
      when :undeployed
        label_with_default_tag(state)
      else
        label_with_default_tag(state)
      end
    end


    def options_for_manage_application
      [
        [t('.select.options.start'), 'start'],
        [t('.select.options.stop'), 'stop'],
        [t('.select.options.restart'), 'restart']
      ]
    end

  end
end
