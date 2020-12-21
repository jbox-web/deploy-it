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

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |menu|
    menu.dom_id = 'side-menu'
    menu.dom_class = 'nav'
    if current_site_user.admin?
      menu.item :users,             *menu_entry_for_model('User', namespace: :admin)
      menu.item :groups,            *menu_entry_for_model('Group', namespace: :admin)
      menu.item :roles,             *menu_entry_for_model('Role', namespace: :admin)
      menu.item :application_types, *menu_entry_for_model('ApplicationType', namespace: :admin)
      menu.item :platforms,         *menu_entry_for_model('Platform', namespace: :admin)
      menu.item :docker_images,     *menu_entry_for_model('DockerImage', namespace: :admin)
      menu.item :buildpacks,        *menu_entry_for_model('Buildpack', namespace: :admin)
      menu.item :reserved_names,    *menu_entry_for_model('ReservedName', namespace: :admin)
      menu.item :applications,      *menu_entry_for_model('Application', namespace: :admin)
      menu.item :locks,             *menu_entry_for_model('Lock', namespace: :admin)

      menu.item :settings, { icon: icon_for_entry('fa-gear'),  text: label_for_entry(t('text.settings')) }, admin_settings_path
      menu.item :sidekiq,  { icon: icon_for_entry('fa-gears'), text: label_for_entry(t('text.sidekiq')) }, sidekiq_web_path, link_html: { target: '_blank' }
    end
  end
end
