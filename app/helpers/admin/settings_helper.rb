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
  module SettingsHelper

    SETTINGS_ICON_MAPPING = {
      rails_config:         'fa-gears',
      db_config:            'fa-database',
      redis_config:         'fa-database',
      app_config:           'fa-gears',
      devise_config:        'fa-shield',
      smtp_config:          'fa-envelope',
      monitoring_config:    'fa-heartbeat',
    }.freeze

    def settings_icon_for(group_name)
      SETTINGS_ICON_MAPPING[group_name] || 'fa-gears'
    end

  end
end
