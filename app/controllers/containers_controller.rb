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

class ContainersController < ApplicationController

  before_action :require_login
  before_action :set_application
  before_action :set_container
  before_action :set_deployment_action, only: :manage
  # before_action :authorize


  def infos
    render layout: false
  end


  def manage
    @container.run_async!(@deploy_action.to_method, async_view_refresh(:containers_toolbar))
    render_ajax_response
  end


  private


    def set_application
      begin
        @application = Application.find(params[:application_id])
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
      @deploy_action = @container.find_active_use_case(params[:deploy_action])
    rescue UseCaseNotDefinedError => e
      render_403
    end

end
