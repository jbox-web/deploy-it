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

class ApplicationsConfigController < ApplicationController

  include DCI::Controllers::Application
  set_dci_role 'DCI::Roles::ApplicationConfigManager'

  before_action :set_application


  def settings
    dci_data = [:name, :domain_name, :application_type_id, :instance_number, :image_type, :buildpack, :use_credentials, :use_cron, :use_ssl, :debug_mode]
    set_dci_data({ application: dci_data })
    call_dci_role(:update_settings)
  end


  def repository
    set_dci_data({ application_repository: [:url, :branch, :have_credentials, :credential_id] })
    call_dci_role(:update_repository)
  end


  def credentials
    set_dci_data({ application: { credentials_attributes: [:id, :login, :password, :_destroy] } })
    call_dci_role(:update_credentials)
  end


  def env_vars
    set_dci_data({ application: { env_vars_attributes: [:id, :key, :value, :step, :masked, :_destroy] } })
    call_dci_role(:update_env_vars)
  end


  def mount_points
    set_dci_data({ application: { mount_points_attributes: [:id, :source, :target, :step, :active, :_destroy] } })
    call_dci_role(:update_mount_points)
  end


  def domain_names
    set_dci_data({ application: { domain_names_attributes: [:id, :domain_name, :mode, :_destroy] } })
    call_dci_role(:update_domain_names)
  end


  def addons
    set_dci_data({ application: { addons_attributes: [:id, :params, :_destroy] } })
    call_dci_role(:update_addons)
  end


  def ssl_certificate
    set_dci_data({ ssl_certificate: [:ssl_crt, :ssl_key], rescue: true })
    call_dci_role(:ssl_certificate)
  end


  def database
    set_dci_data({ application: { database_attributes: [:id, :server_id] } })
    call_dci_role(:update_database)
  end


  def synchronize_repository
    set_dci_data(event_options_for(:synchronize_repository).merge(strong_params: false))
    call_dci_role(:synchronize_repository)
  end


  def add_addon
    set_dci_data({ application_addon: [:addon_id], rescue: true })
    request.post? ? call_dci_role(:add_addon) : render_modal_box
  end


  def restore_env_vars
    call_dci_role(:restore_env_vars)
  end


  def restore_mount_points
    call_dci_role(:restore_mount_points)
  end


  def reset_ssl_certificate
    call_dci_role(:reset_ssl_certificate)
  end


  private


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


    def render_modal_box(locals: {})
      super(locals: { application: @application, addon: @application.addons.new })
    end

end
