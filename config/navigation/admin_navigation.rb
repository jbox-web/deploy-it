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
    menu.item :users,             label_with_icon(get_model_name_for('User'), 'fa-user'), admin_users_path
    menu.item :groups,            label_with_icon(get_model_name_for('Group'), 'fa-users'), admin_groups_path
    menu.item :roles,             label_with_icon(get_model_name_for('Role'), 'fa-database'), admin_roles_path
    menu.item :application_types, label_with_icon(get_model_name_for('ApplicationType'), 'fa-desktop'), admin_application_types_path
    menu.item :platforms,         label_with_icon(get_model_name_for('Platform'), 'fa-sitemap'), admin_platforms_path
    menu.item :docker_images,     label_with_icon(get_model_name_for('DockerImage'), 'fa-cubes'), admin_docker_images_path
    menu.item :buildpacks,        label_with_icon(get_model_name_for('Buildpack'), 'fa-rocket'), admin_buildpacks_path
    menu.item :reserved_names,    label_with_icon(get_model_name_for('ReservedName'), 'fa-shield'), admin_reserved_names_path
    menu.item :applications,      label_with_icon(get_model_name_for('Application'), 'fa-desktop'), admin_applications_path
    menu.item :locks,             label_with_icon(get_model_name_for('Lock'), 'fa-lock'), admin_locks_path
    menu.item :settings,          label_with_icon(t('layouts.sidebar.settings'), 'fa-info-circle'), admin_settings_path
    menu.item :sidekiq,           label_with_icon(t('layouts.sidebar.sidekiq'), 'fa-gears'), sidekiq_web_path
    menu.item :logster,           label_with_icon(t('layouts.sidebar.logster'), 'fa-book'), logster_web_path
  end
end
