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

class ApplicationConfigContext < ContextBase

  include ApplicationCommon


  def update_settings(application, params = {})
    update_application(application, params) do |application|
      application.run_async!('update_files!')
    end
  end


  def update_repository(application, params = {})
    repository = application.distant_repo
    if repository.update(params)
      # Destroy Application repository if url has changed.
      # It will be recloned by service object.
      repository.destroy_dir! if repository.url_has_changed? || repository.branch_has_changed?

      # Call service objects to perform other actions
      !repository.exists? ? repository.run_async!('clone!') : repository.run_async!('resync!')
      context.render_success(locals: { application: application })
    else
      context.render_failed(locals: { application: application })
    end
  end


  def update_domain_names(application, params = {})
    update_application(application, params)
  end


  def update_credentials(application, params = {})
    update_application(application, params) do |application|
      application.create_lb_route!
    end
  end


  def update_env_vars(application, params = {})
    update_application(application, params) do |application|
      application.run_async!('update_files!')
    end
  end


  def update_mount_points(application, params = {})
    update_application(application, params) do |application|
      application.run_async!('update_files!')
    end
  end


  def ssl_certificate(application, params = {})
    return context.render_failed(locals: { application: application }, message: t('.already_exist')) unless application.ssl_certificate.nil?
    certificate = application.build_ssl_certificate(params)
    if certificate.save
      application.create_lb_route!
      context.render_success(locals: { application: application })
    else
      context.render_failed(locals: { application: application })
    end
  end


  def update_database(application, params = {})
    update_application(application, params) do |application|
      application.run_async!('create_physical_database!')
    end
  end


  def synchronize_repository(application, opts = {})
    application.distant_repo.run_async!('resync!', opts)
    context.render_success(locals: { application: application })
  end


  def restore_env_vars(application, params = {})
    execute_action(application, params) do |application|
      application.restore_env_vars!
    end
  end


  def restore_mount_points(application, params = {})
    execute_action(application, params) do |application|
      application.restore_mount_points!
    end
  end


  def reset_ssl_certificate(application, params = {})
    application.ssl_certificate = nil
    context.render_success(locals: { application: application })
  end

end
