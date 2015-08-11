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

class ApplicationsManagerController < ApplicationController

  include Contextable

  before_action :set_application_by_id,     only: [:build_application, :manage_application]
  before_action :set_application_by_app_id, only: [:container_infos, :manage_container]

  before_action :set_container,         only: [:container_infos, :manage_container]
  before_action :set_deployment_action, only: [:manage_application, :manage_container]



  def build_application
    ApplicationManagementContext.new(self).build_application(@application)
  end


  def manage_application
    ApplicationManagementContext.new(self).manage_application(@application, @deploy_action)
  end


  def container_infos
    render layout: false, locals: { container: @container }
  end


  def manage_container
    ApplicationManagementContext.new(self).manage_container(@application, @container, @deploy_action)
  end


  private


    def set_application_by_id
      set_application(params[:id])
    end


    def set_application_by_app_id
      set_application(params[:application_id])
    end


    def set_application(param)
      begin
        @application = Application.find(param)
      rescue ActiveRecord::RecordNotFound => e
        render_404
      end
    end


    def set_container
      begin
        @container = @application.containers.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render_404
      end
    end


    def set_deployment_action
      @deploy_action = @application.find_active_use_case(params[:deploy_action])
    rescue UseCaseNotDefinedError => e
      render_403
    end

end
