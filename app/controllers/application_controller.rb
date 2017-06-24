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

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception

  include BaseController::Devise
  include BaseController::UserSettings
  include BaseController::Ajax
  include BaseController::Authorizations
  include BaseController::Tools
  include BaseController::Helpers
  include BaseController::Menus


  def set_application
    set_application_by(params[:id])
  end


  def set_user
    set_user_by(params[:id])
  end


  def set_member
    set_member_by(params[:id])
  end


  def set_credential
    set_credential_by(params[:id])
  end


  def set_user_by(param)
    @user = User.find(param)
  rescue ActiveRecord::RecordNotFound => e
    render_404
  end


  def set_application_by(param)
    begin
      @application = Application.find(param)
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end
  end


  def set_member_by(param)
    @member = Member.find(param)
  rescue ActiveRecord::RecordNotFound => e
    render_404
  end


  def set_container_by(param)
    begin
      @container = @application.containers.find(param)
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end
  end


  def set_credential_by(params)
    @credential = RepositoryCredential.find(params)
  rescue ActiveRecord::RecordNotFound => e
    render_404
  end


  def set_deployment_action_for(object)
    @deploy_action = object.find_active_use_case(params[:deploy_action])
  rescue UseCaseNotDefinedError => e
    render_403
  end


  def event_options_for(method)
    case method
    when :synchronize_repository
      { async_view_refresh: RefreshViewEvent.create(app_id: @application.id, action: 'repositories', triggers: [repositories_application_path(@application)]) }
    when :toolbar
      { async_view_refresh: RefreshViewEvent.create(app_id: @application.id, action: 'containers', triggers: [toolbar_application_path(@application), status_application_path(@application)]) }
    else
      {}
    end
  end


  def add_global_crumb
    add_breadcrumb @application.fullname, 'fa-desktop', infos_application_path(@application)
  end

end
