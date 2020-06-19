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

    if @application
      application = @application

      menu.item :app_infos,
                { text: t('text.informations'), icon: icon_for_entry('fa-info-circle') },
                infos_application_path(application)

      menu.item :app_repositories,
                { text: t('text.code'), icon: icon_for_entry('fa-code') },
                repositories_application_path(application)

      menu.item :app_containers,
                { text: get_model_name_for('Container'), icon: icon_for_entry('fa-rocket') },
                containers_application_path(application)

      menu.item :app_activities,
                { text: t('text.activities'), icon: icon_for_entry('fa-clock-o') },
                activities_application_path(application)

      menu.item :app_events,
                { text: get_model_name_for('ContainerEvent'), icon: icon_for_entry('fa-commenting') },
                events_application_path(application)

      menu.item :app_settings,
                { text: get_model_name_for('Settings'), icon: icon_for_entry('fa-sliders') },
                settings_application_path(application), if: -> { can?(:edit_application, application) }

      menu.item :app_members,
                { text: get_model_name_for('Member'), icon: icon_for_entry('fa-users') },
                application_members_path(application), if: -> { can?(:manage_members, application) }

      menu.item :app_repository,
                { text: get_model_name_for('Repository'), icon: icon_for_entry('fa-git') },
                repository_application_path(application), if: -> { can?(:edit_application, application) }

      menu.item :app_domain_names,
                { text: get_model_name_for('DomainName'), icon: icon_for_entry('fa-random') },
                domain_names_application_path(application), if: -> { can?(:edit_application, application) }

      menu.item :app_env_vars,
                { text: get_model_name_for('EnvVar'), icon: icon_for_entry('fa-list-ul') },
                env_vars_application_path(application), if: -> { can?(:edit_application, application) }

      menu.item :app_mount_points,
                { text: get_model_name_for('MountPoint'), icon: icon_for_entry('fa-download') },
                mount_points_application_path(application), if: -> { can?(:edit_application, application) }

      menu.item :app_credentials,
                { text: get_model_name_for('ApplicationCredential'), icon: icon_for_entry('fa-eye') },
                credentials_application_path(application), if: -> { can?(:edit_application, application) }

      menu.item :app_addons,
                { text: get_model_name_for('ApplicationAddon'), icon: icon_for_entry('fa-cube') },
                addons_application_path(application), if: -> { can?(:edit_application, application) }

      menu.item :app_ssl_certificate,
                { text: get_model_name_for('SslCertificate',  pluralize: false), icon: icon_for_entry('fa-shield') },
                ssl_certificate_application_path(application), if: -> { can?(:edit_application, application) }

      menu.item :app_database,
                { text: get_model_name_for('ApplicationDatabase'), icon: icon_for_entry('fa-database') },
                database_application_path(application), if: -> { can?(:edit_application, application) }

    else

      menu.item :applications,
                { text: get_model_name_for('Application'), icon: icon_for_entry('fa-desktop') },
                applications_path, highlights_on: %r(\A/applications\z)

      menu.item :new_application,
                { text: t('text.new_application'), icon: icon_for_entry('fa-plus') },
                new_application_path, if: -> { can?(:create_application, nil, global: true) }

      menu.item :new_credentials,
                { text: t('text.new_credentials'), icon: icon_for_entry('fa-plus') },
                new_credential_path, if: -> { can?(:create_credential, nil, global: true) }

    end
  end
end
