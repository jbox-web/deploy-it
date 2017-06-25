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

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |menu|
    menu.dom_class = 'navbar-top-links navbar-right'
    if current_site_user.logged?
      menu.item :applications, get_model_name_for('Application'), applications_path
      menu.item :admin,        t('text.admin'), admin_root_path, if: -> { current_site_user.admin? }

      menu.item :logged, current_site_user.email, my_account_path, highlights_on: %r(/my), class: 'dropdown' do |sub_menu|
        sub_menu.auto_highlight = false
        sub_menu.item :my_account, t('text.my_account'), my_account_path, highlights_on: %r(/my)
        sub_menu.item :help,       t('text.help'), help_path, highlights_on: :subpath
        sub_menu.item :divider, '', '', class: :divider, role: :presentation
        sub_menu.item :logout,     t('text.logout'), destroy_user_session_path, method: :delete
      end
    else
      menu.item :login, { icon: icon_for_entry('fa-sign-in'), text: label_for_entry(t('text.login')) }, new_user_session_path
    end
  end
end
