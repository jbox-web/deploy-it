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

module DeployIt
  module Theme

    FONT_AWESOME_MAPPING = {
      success: 'fa-check',
      error:   'fa-exclamation',
      alert:   'fa-exclamation',
      warning: 'fa-warning',
      info:    'fa-info-circle',
      notice:  'fa-info-circle'
    }

    BOOTSTRAP_NOTIFY_MAPPING = {
      success: 'success',
      error:   'danger',
      alert:   'danger',
      warning: 'warning',
      info:    'info',
      notice:  'info'
    }

    BOOTSTRAP_ALERT_MAPPING = {
      success: 'alert-success',
      error:   'alert-danger',
      alert:   'alert-danger',
      warning: 'alert-warning',
      info:    'alert-info',
      notice:  'alert-info'
    }

    FONT_AWESOME_DEFAULT_CLASS    = ['fa', 'fa-align']
    BOOTSTRAP_ALERT_DEFAULT_CLASS = ['alert', 'fade', 'in']

    MEMORY_ICONS_MAPPING = {
      128  => 'fa-battery-1',
      256  => 'fa-battery-1',
      384  => 'fa-battery-2',
      512  => 'fa-battery-2',
      640  => 'fa-battery-3',
      768  => 'fa-battery-3',
      896  => 'fa-battery-4',
      1024 => 'fa-battery-4'
    }

  end
end
