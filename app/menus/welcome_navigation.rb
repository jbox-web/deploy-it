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

class WelcomeNavigation < BaseNavigation

  def nav_menu
    sidebar_menu do |menu|
      menu.item with_prefix(:my_profile),   label_with_icon(t('layouts.sidebar.my_account'), 'fa-user'), my_account_path
      menu.item with_prefix(:applications), label_with_icon(get_model_name_for('Application'), 'fa-desktop'), applications_path
      menu.item with_prefix(:admin),        label_with_icon(t('layouts.sidebar.admin'), 'fa-cog'), admin_root_path, if: -> { User.current.admin? }
      menu.item with_prefix(:help),         label_with_icon(t('layouts.sidebar.help'), 'fa-book'), help_path
    end
  end


  def renderable?
    welcome_section?
  end

end
