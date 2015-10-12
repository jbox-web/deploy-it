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

class ApplicationsConfigController < DCIController

  include DCI::Controllers::Application
  set_dci_role 'DCI::Roles::ApplicationConfigManager'

  layout 'application'

  before_action :set_application
  before_action :authorize
  before_action :add_global_crumb


  def settings
    add_breadcrumb get_model_name_for('Settings'), 'fa-sliders', ''
    dci_data = [:name, :domain_name, :application_type_id, :max_memory, :instance_number, :image_type, :buildpack, :use_credentials, :use_cron, :use_ssl, :debug_mode]
    set_dci_data({ application: dci_data })
    wrapped_response { call_dci_role(:update_settings) }
  end


  def repository
    add_breadcrumb get_model_name_for('Repository', pluralize: false), 'fa-git', ''
    set_dci_data({ application_repository: [:url, :branch, :have_credentials, :credential_id] })
    wrapped_response { call_dci_role(:update_repository) }
  end


  def credentials
    add_breadcrumb get_model_name_for('ApplicationCredential'), 'fa-eye', ''
    set_dci_data({ application: { credentials_attributes: [:id, :login, :password, :_destroy] } })
    wrapped_response { call_dci_role(:update_credentials) }
  end


  def env_vars
    add_breadcrumb get_model_name_for('EnvVar'), 'fa-list-ul', ''
    set_dci_data({ application: { env_vars_attributes: [:id, :key, :value, :step, :masked, :_destroy] } })
    wrapped_response { call_dci_role(:update_env_vars) }
  end


  def mount_points
    add_breadcrumb get_model_name_for('MountPoint'), 'fa-download', ''
    set_dci_data({ application: { mount_points_attributes: [:id, :source, :target, :step, :active, :_destroy] } })
    wrapped_response { call_dci_role(:update_mount_points) }
  end


  def domain_names
    add_breadcrumb get_model_name_for('DomainName'), 'fa-random', ''
    set_dci_data({ application: { domain_names_attributes: [:id, :domain_name, :mode, :_destroy] } })
    wrapped_response { call_dci_role(:update_domain_names) }
  end


  def addons
    add_breadcrumb get_model_name_for('Addon'), 'fa-cubes', ''
    set_dci_data({ application: { addons_attributes: [:id, :params, :_destroy] } })
    wrapped_response { call_dci_role(:update_addons) }
  end


  def ssl_certificate
    add_breadcrumb get_model_name_for('SslCertificate', pluralize: false), 'fa-shield', ''
    set_dci_data({ ssl_certificate: [:ssl_crt, :ssl_key] })
    wrapped_response { call_dci_role(:ssl_certificate) }
  end


  def database
    add_breadcrumb get_model_name_for('ApplicationDatabase', pluralize: false), 'fa-database', ''
    set_dci_data({ application: { database_attributes: [:id, :server_id] } })
    wrapped_response { call_dci_role(:update_database) }
  end


  def synchronize_repository
    set_dci_data(event_options_for(:synchronize_repository).merge(strong_params: false))
    call_dci_role(:synchronize_repository)
  end


  def add_addon
    add_breadcrumb get_model_name_for('Addon'), 'fa-cubes', ''
    set_dci_data({ application_addon: [:addon_id], rescue: true })
    request.post? ? call_dci_role(:add_addon) : render_modal_box(locals: { application: @application, addon: @application.addons.new })
  end


  def restore_env_vars
    add_breadcrumb get_model_name_for('EnvVar'), 'fa-list-ul', ''
    call_dci_role(:restore_env_vars)
  end


  def restore_mount_points
    add_breadcrumb get_model_name_for('MountPoint'), 'fa-download', ''
    call_dci_role(:restore_mount_points)
  end


  def reset_ssl_certificate
    add_breadcrumb get_model_name_for('SslCertificate', pluralize: false), 'fa-shield', ''
    call_dci_role(:reset_ssl_certificate)
  end


  private


    def wrapped_response(&block)
      request.patch? ? yield : render_multi_responses
    end


    def render_multi_responses(template: action_name, partial: action_name, locals: {})
      super(template: "applications_config/#{template}", partial: "applications_config/partials/#{partial}", locals: { application: @application })
    end


    def get_template(action: action_name)
      case action
      when 'restore_env_vars'
        'env_vars'
      when 'restore_mount_points'
        'mount_points'
      when 'reset_ssl_certificate'
        'ssl_certificate'
      else
        super
      end
    end

end
