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

class DCIController < ApplicationController
  include DCI::Contexts::Controller


  private


    def call_dci_role(method, *args)
      super method, @application, *args
    end


    def set_application_by(param)
      begin
        @application = Application.find(param)
      rescue ActiveRecord::RecordNotFound => e
        render_404
      end
    end


    def set_container_by(param)
      begin
        @container = @application.containers.find(param)
      rescue ActiveRecord::RecordNotFound => e
        render_404
      end
    end


    def set_deployment_action_for(object)
      @deploy_action = object.find_active_use_case(params[:deploy_action])
    rescue UseCaseNotDefinedError => e
      render_403
    end


    def set_member_by(param)
      @member = Member.find(param)
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def event_options_for(method)
      case method
      when :synchronize_repository
        { async_view_refresh: RefreshViewEvent.create(app_id: @application.id, triggers: [repositories_application_path(@application)]) }
      when :toolbar
        { async_view_refresh: RefreshViewEvent.create(app_id: @application.id, triggers: [toolbar_application_path(@application), status_application_path(@application)]) }
      else
        {}
      end
    end


    def render_modal_box(locals: {})
      render layout: modal_or_application_layout, locals: locals
    end


    def modal_or_application_layout
      request.xhr? ? 'modal' : 'application'
    end

end
