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

class Admin::ApplicationsController < Admin::DefaultController

  before_action :find_applications
  before_action :validate_params,  only: [:manage]


  def index
    add_crumb label_with_icon(Application.model_name.human(count: 2), 'fa-desktop', fixed: true), '#'
  end


  def manage
    params[:application_ids].each do |id|
      application = Application.find_by_id(id)
      options = { event_options: event_options(application) }
      if params[:deploy_action] == 'update_route'
        application.update_lb_route!(options)
      else
        deploy_action = application.find_active_use_case(params[:deploy_action])
        application.run_async!(deploy_action.to_method, options)
      end
    end
    flash[:notice] = t('.success.action.enqueue')
    render_ajax_response
  end


  def status
    @after_action = params[:after_action] || false
    @application = Application.find_by_id(params[:application_id])
    render_ajax_response
  end


  private


    def find_applications
      @applications = Application.includes([:stage, :containers, :application_type]).all.sort_by(&:fullname)
    end


    def validate_params
      if !params.has_key?(:deploy_action) || params[:deploy_action].blank?
        flash[:alert] = t('.error.action.empty')
        return render_ajax_response
      end

      if !params.has_key?(:application_ids) || params[:application_ids].empty?
        flash[:alert] = t('.error.application_ids.empty')
        return render_ajax_response
      end

      if !valid_actions.include?(params[:deploy_action])
        flash[:alert] = t('.error.action.invalid')
        return render_ajax_response
      end
    end


    def valid_actions
      ['start', 'stop', 'restart', 'update_route']
    end


    def event_options(application)
      RefreshViewEvent.create(controller: 'admin/applications', action: 'index', triggers: triggers(application))
    end


    def triggers(application)
      [admin_application_status_path(application, after_action: true)]
    end

end
