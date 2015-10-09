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

  set_dci_role 'DCI::Roles::ApplicationManager'

  before_action :set_application
  before_action :set_container
  before_action :set_deployment_action, only: [:manage_container]


  def manage_container
    set_dci_data(event_options_for(:toolbar).merge(strong_params: false))
    call_dci_role(:manage_container, @container, @deploy_action)
  end


  def container_infos
    render_modal_box
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


    def render_modal_box(locals: {})
      super(locals: { container: @container })
    end

end
