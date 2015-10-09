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

  include DCI::Context

  before_action :set_application

  # TODO:
  # before_action :authorize


  def settings
    required_params = [:name, :domain_name, :application_type_id, :instance_number, :image_type, :buildpack, :use_credentials, :use_cron, :use_ssl, :debug_mode]
    set_required_params({ application: required_params })
    call_context(:update_settings)
  end


  def repository
    set_required_params({ application_repository: [:url, :branch, :have_credentials, :credential_id] })
    call_context(:update_repository)
  end


  def credentials
    set_required_params({ application: { credentials_attributes: [:id, :login, :password, :_destroy] } })
    call_context(:update_credentials)
  end


  def env_vars
    set_required_params({ application: { env_vars_attributes: [:id, :key, :value, :step, :masked, :_destroy] } })
    call_context(:update_env_vars)
  end


  def mount_points
    set_required_params({ application: { mount_points_attributes: [:id, :source, :target, :step, :active, :_destroy] } })
    call_context(:update_mount_points)
  end


  def domain_names
    set_required_params({ application: { domain_names_attributes: [:id, :domain_name, :mode, :_destroy] } })
    call_context(:update_domain_names)
  end


  def addons
    set_required_params({ application: { addons_attributes: [:id, :params, :_destroy] } })
    call_context(:update_addons)
  end


  def ssl_certificate
    set_required_params({ ssl_certificate: [:ssl_crt, :ssl_key], rescue: true })
    call_context(:ssl_certificate)
  end


  def database
    set_required_params({ application: { database_attributes: [:id, :server_id] } })
    call_context(:update_database)
  end


  def synchronize_repository
    set_required_params(event_options.merge(strong_params: false))
    call_context(:synchronize_repository)
  end


  def add_addon
    set_required_params({ application_addon: [:addon_id], rescue: true })

    if request.post?
      call_context(:add_addon)
    else
      @addon = @application.addons.new
      render layout: modal_or_application_layout
    end
  end


  def restore_env_vars
    set_required_params({ strong_params: false })
    call_context(:restore_env_vars)
  end


  def restore_mount_points
    set_required_params({ strong_params: false })
    call_context(:restore_mount_points)
  end


  def reset_ssl_certificate
    set_required_params({ strong_params: false })
    call_context(:reset_ssl_certificate)
  end


  private


    def call_context(method)
      DCI::Roles::ApplicationConfigManager.new(self).send(method, @application, get_required_params)
    end


    def set_application
      @application = Application.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
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
        action
      end
    end


    def event_options
      { async_view_refresh: RefreshViewEvent.create(app_id: @application.id, triggers: [repositories_application_path(@application)]) }
    end


    def modal_or_application_layout
      request.xhr? ? 'modal' : 'application'
    end

end
