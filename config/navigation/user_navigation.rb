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

    if @application
      application = @application

      menu.item :app_infos,           label_with_icon(t('layouts.sidebar.informations'), 'fa-info-circle'),   infos_application_path(application)
      menu.item :app_repositories,    label_with_icon(t('layouts.sidebar.code'), 'fa-code'),                  repositories_application_path(application)
      menu.item :app_containers,      label_with_icon(get_model_name_for('Container'), 'fa-rocket'),          containers_application_path(application)
      menu.item :app_activities,      label_with_icon(t('layouts.sidebar.activities'), 'fa-clock-o'),         activities_application_path(application)
      menu.item :app_events,          label_with_icon(get_model_name_for('ContainerEvent'), 'fa-commenting'), events_application_path(application)
      menu.item :app_settings,        label_with_icon(get_model_name_for('Settings'), 'fa-sliders'),          settings_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item :app_members,         label_with_icon(get_model_name_for('Member'), 'fa-users'),              application_members_path(application), if: -> { can?(:manage_members, application) }
      menu.item :app_repository,      label_with_icon(get_model_name_for('Repository'), 'fa-git'),            repository_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item :app_domain_names,    label_with_icon(get_model_name_for('DomainName'), 'fa-random'),         domain_names_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item :app_env_vars,        label_with_icon(get_model_name_for('EnvVar'), 'fa-list-ul'),            env_vars_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item :app_mount_points,    label_with_icon(get_model_name_for('MountPoint'), 'fa-download'),       mount_points_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item :app_credentials,     label_with_icon(get_model_name_for('ApplicationCredential'), 'fa-eye'), credentials_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item :app_addons,          label_with_icon(get_model_name_for('ApplicationAddon'), 'fa-cube'),     addons_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item :app_ssl_certificate, label_with_icon(get_model_name_for('SslCertificate', pluralize: false), 'fa-shield'), ssl_certificate_application_path(application), if: -> { can?(:edit_application, application) }
      menu.item :app_database,        label_with_icon(get_model_name_for('ApplicationDatabase'), 'fa-database'), database_application_path(application), if: -> { can?(:edit_application, application) }
    else
      menu.item :applications,    label_with_icon(get_model_name_for('Application'), 'fa-desktop'), applications_path, highlights_on: %r(\A/applications\z)
      menu.item :new_application, label_with_icon(t('layouts.sidebar.new_application'), 'fa-plus'), new_application_path, if: -> { can?(:create_application, nil, global: true) }

      menu.item :new_credentials, label_with_icon(t('layouts.sidebar.new_credentials'), 'fa-plus'), new_credential_path, if: -> { can?(:create_credential, nil, global: true) }

      RepositoryCredential.all.each do |credential|
        menu.item :credential, label_with_icon(credential.name, 'octicon octicon-key'), edit_credential_path(credential), if: -> { can?(:edit_credential, nil, global: true) }
      end
    end
  end
end
