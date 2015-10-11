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

class ApplicationsManagerController < DCIController

  include DCI::Controllers::Application
  set_dci_role 'DCI::Roles::ApplicationManager'

  before_action :set_application
  before_action :set_deployment_action, only: [:manage]



  def build
    set_dci_data(event_options_for(:toolbar).merge(strong_params: false, logger: 'console_streamer'))
    call_dci_role(:build_application, User.current, @application.pushes.last)
  end


  def manage
    set_dci_data(event_options_for(:toolbar).merge(strong_params: false))
    call_dci_role(:manage_application, @deploy_action)
  end


  def toolbar
    render_ajax_response(locals: { application: @application })
  end


  def status
    render_ajax_response(locals: { application: @application })
  end


  private


    def set_deployment_action
      set_deployment_action_for(@application)
    end

end
