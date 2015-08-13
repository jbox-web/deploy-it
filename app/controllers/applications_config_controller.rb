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

  include Contextable

  before_action :set_application

  # TODO:
  # before_action :authorize


  def settings
    call_context(:update_settings)
  end


  def repository
    call_context(:update_repository)
  end


  def credentials
    call_context(:update_credentials)
  end


  def env_vars
    call_context(:update_env_vars)
  end


  def mount_points
    call_context(:update_mount_points)
  end


  def domain_names
    call_context(:update_domain_names)
  end


  def ssl_certificate
    call_context(:ssl_certificate)
  end


  def database
    call_context(:update_database)
  end


  def synchronize_repository
    call_context(:synchronize_repository)
  end


  def restore_env_vars
    call_context(:restore_env_vars)
  end


  def restore_mount_points
    call_context(:restore_mount_points)
  end


  def reset_ssl_certificate
    call_context(:reset_ssl_certificate)
  end


  private


    def call_context(method)
      ApplicationConfigContext.new(self).send(method, @application, get_params)
    end


    def set_application
      @application = Application.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def get_params(action: action_name)
      case action
      when 'settings'
        params.require(:application).permit(:name, :domain_name, :application_type_id, :instance_number, :image_type, :buildpack,
          :use_credentials, :use_cron, :use_ssl, :debug_mode)
      when 'repository'
        params.require(:application_repository).permit(:url, :branch, :have_credentials, :credential_id)
      when 'credentials'
        params.require(:application).permit(credentials_attributes: [:id, :login, :password, :_destroy])
      when 'env_vars'
        params.require(:application).permit(env_vars_attributes: [:id, :key, :value, :step, :masked, :_destroy])
      when 'mount_points'
        params.require(:application).permit(mount_points_attributes: [:id, :source, :target, :step, :active, :_destroy])
      when 'domain_names'
        params.require(:application).permit(domain_names_attributes: [:id, :domain_name, :mode, :_destroy])
      when 'ssl_certificate'
        params.require(:ssl_certificate).permit(:ssl_crt, :ssl_key) rescue {}
      when 'database'
        params.require(:application).permit(database_attributes: [:id, :server_id])
      when 'synchronize_repository'
        event_options
      else
        {}
      end
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

end
