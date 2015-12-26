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

class ApplicationNavigation < BaseNavigation

  def render(opts = {})
    menu = super
    render_application_select_box(class: 'navbar-form') + menu if renderable?
  end


  def nav_menu
    application = opts[:application]

    sidebar_menu do |menu|
      menu.item with_prefix(:app_infos),           label_with_icon(t('layouts.sidebar.informations'), 'fa-info-circle'),   infos_application_path(application)
      menu.item with_prefix(:app_repositories),    label_with_icon(t('layouts.sidebar.code'), 'fa-code'),                  repositories_application_path(application)
      menu.item with_prefix(:app_containers),      label_with_icon(get_model_name_for('Container'), 'fa-rocket'),          containers_application_path(application)
      menu.item with_prefix(:app_activities),      label_with_icon(t('layouts.sidebar.activities'), 'fa-clock-o'),         activities_application_path(application)
      menu.item with_prefix(:app_events),          label_with_icon(get_model_name_for('ContainerEvent'), 'fa-commenting'), events_application_path(application)
      menu.item with_prefix(:app_settings),        label_with_icon(get_model_name_for('Settings'), 'fa-sliders'),          settings_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item with_prefix(:app_members),         label_with_icon(get_model_name_for('Member'), 'fa-users'),              application_members_path(application), if: -> { can?(:manage_members, application) }
      menu.item with_prefix(:app_repository),      label_with_icon(get_model_name_for('Repository'), 'fa-git'),            repository_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item with_prefix(:app_domain_names),    label_with_icon(get_model_name_for('DomainName'), 'fa-random'),         domain_names_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item with_prefix(:app_env_vars),        label_with_icon(get_model_name_for('EnvVar'), 'fa-list-ul'),            env_vars_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item with_prefix(:app_mount_points),    label_with_icon(get_model_name_for('MountPoint'), 'fa-download'),       mount_points_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item with_prefix(:app_credentials),     label_with_icon(get_model_name_for('ApplicationCredential'), 'fa-eye'), credentials_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item with_prefix(:app_addons),          label_with_icon(get_model_name_for('ApplicationAddon'), 'fa-cube'),     addons_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item with_prefix(:app_ssl_certificate), label_with_icon(get_model_name_for('SslCertificate', pluralize: false), 'fa-shield'), ssl_certificate_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item with_prefix(:app_database),        label_with_icon(get_model_name_for('ApplicationDatabase'), 'fa-database'), database_application_path(application), if: -> { can?(:edit_application, application) }
    end
  end


  def renderable?
    show_application_section?
  end

end
