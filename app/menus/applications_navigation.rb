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

class ApplicationsNavigation < BaseNavigation

  def nav_menu
    sidebar_menu do |menu|
      menu.item with_prefix(:applications),    label_with_icon(get_model_name_for('Application'), 'fa-desktop'), applications_path, highlights_on: %r(\A/applications\z)
      menu.item with_prefix(:new_application), label_with_icon(t('layouts.sidebar.new_application'), 'fa-plus'), new_application_path, if: -> { can?(:create_application, nil, global: true) }
    end
  end


  def renderable?
    application_section? || credential_section? || show_application_section?
  end

end
