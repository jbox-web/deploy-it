# frozen_string_literal: true
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

class ContainersManagerController < DCIController

  include DCI::Controllers::Application
  set_dci_role 'DCI::Roles::ApplicationManager'

  before_action :set_application
  before_action :set_container
  before_action :set_deployment_action, only: [:manage]


  def manage
    set_dci_data(event_options_for(:toolbar).merge(strong_params: false))
    call_dci_role(:manage_container, @container, @deploy_action)
  end


  def infos
    render_modal_box(locals: { container: @container })
  end


  def top
    respond_to do |format|
      format.html { render_modal_box(locals: { container: @container }) }
      format.js   { render ajax_template_path(action_name), locals: { container: @container } }
    end
  end


  def events
    if request.post?
      return render json: ContainerEventDatatable.new(params, view_context: view_context, container: @container)
    end
  end


  def mark_events
    @container.events.not_seen.map(&:seen!)
    render_ajax_response(locals: { container: @container })
  end


  private


    def set_application
      set_application_by(params[:application_id])
    end


    def set_container
      set_container_by(params[:id])
    end


    def set_deployment_action
      set_deployment_action_for(@container)
    end

end
