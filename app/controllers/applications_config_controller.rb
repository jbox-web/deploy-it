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

  before_action :set_application

  # TODO:
  # before_action :authorize, only: [:index, :show, :new, :create, :edit, :update, :destroy]


  def repository
    repository = @application.distant_repo
    if repository.update(repository_params)
      # Destroy Application repository if url has changed.
      # It will be recloned by service object.
      repository.destroy_dir! if repository.url_has_changed? || repository.branch_has_changed?

      # Call service objects to perform other actions
      !repository.exists? ? repository.run_async!('clone!') : repository.run_async!('resync!')
    end
    render_ajax_response
  end


  def credentials
    @saved = false
    if @application.update(credentials_params)
      @saved = true
      @application.update_lb_route!
    end
    render_ajax_response
  end


  def env_vars
    @saved = false
    if @application.update(env_vars_params)
      @saved = true
      # Call service objects to perform other actions
      trigger_async_job!('update_files!')
    end
    render_ajax_response
  end


  def mount_points
    @saved = false
    if @application.update(mount_points_params)
      @saved = true
      # Call service objects to perform other actions
      trigger_async_job!('update_files!')
    end
    render_ajax_response
  end


  def domain_names
    @saved = false
    if @application.update(domain_names_params)
      flash[:notice] = t('notice.domain_name.updated')
      @saved = true
    end
    render_ajax_response
  end


  def synchronize_repository
    repository = @application.distant_repo
    # Call service objects to perform other actions
    repository.run_async!('resync!', event_options: async_view_refresh(:repositories))
    render_ajax_response
  end


  def restore_env_vars
    @application.restore_env_vars!
    @saved = true
    # Call service objects to perform other actions
    trigger_async_job!('update_files!')
    render_ajax_response('env_vars')
  end


  def restore_mount_points
    @application.restore_mount_points!
    @saved = true
    # Call service objects to perform other actions
    trigger_async_job!('update_files!')
    render_ajax_response('mount_points')
  end


  def ssl_certificate
    if @application.ssl_certificate.nil?
      ssl_certificate = @application.build_ssl_certificate(ssl_certificate_params)
      flash[:notice] = t('notice.ssl_certificate.created') if ssl_certificate.save
    else
      flash[:error] = t('error.ssl_certificate.already_exists')
    end
    render_ajax_response
  end


  def reset_ssl_certificate
    @application.ssl_certificate = nil
    flash[:notice] = t('notice.ssl_certificate.reseted')
    render_ajax_response('ssl_certificate')
  end


  def database
    if @application.update(database_params)
      flash[:notice] = t('notice.application_database.updated')
    end
    result = @application.create_physical_database!
    flash[:error] = result.message_on_errors if !result.success?
    render_ajax_response
  end


  private


    def set_application
      @application = Application.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def repository_params
      params.require(:application_repository).permit(:url, :branch, :have_credentials, :credential_id)
    end


    def credentials_params
      params.require(:application).permit(credentials_attributes: [:id, :login, :password, :_destroy])
    end


    def env_vars_params
      params.require(:application).permit(env_vars_attributes: [:id, :key, :value, :step, :masked, :_destroy])
    end


    def mount_points_params
      params.require(:application).permit(mount_points_attributes: [:id, :source, :target, :step, :active, :_destroy])
    end


    def domain_names_params
      params.require(:application).permit(domain_names_attributes: [:id, :domain_name, :mode, :_destroy])
    end


    def ssl_certificate_params
      params.require(:ssl_certificate).permit(:ssl_crt, :ssl_key)
    end


    def database_params
      params.require(:application).permit(database_attributes: [:id, :server_id])
    end


    def trigger_async_job!(job)
      @application.run_async!(job)
    end

end
