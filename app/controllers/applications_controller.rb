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

class ApplicationsController < DCIController

  set_dci_role 'DCI::Roles::ApplicationManager'

  before_action :set_application,  except: [:index, :new, :create]
  before_action :authorize,        except: [:index, :new, :create]
  before_action :authorize_global, only:   [:new, :create]
  before_action :load_wizard_form, only:   [:new, :create]


  def index
    add_breadcrumbs
    @applications = Application.visible.all
  end


  def show
    add_breadcrumbs
  end


  def new
    add_breadcrumbs
    self.render_flash_message = false
    render locals: { application: @wizard_form.object }
  end


  def edit
    render_404
  end


  def create
    add_breadcrumbs
    self.render_flash_message = false
    call_dci_role(:create, @wizard_form, User.current)
  end


  def destroy
    call_dci_role(:destroy, @application)
  end


  private


    def load_wizard_form
      @wizard_form = ApplicationCreationWizardForm.new(Application, session, params)
      if action_name.in? %w[new]
        @wizard_form.start
      elsif action_name.in? %w[create]
        @wizard_form.process
      end
    end


    def render_dci_response(template: action_name, locals: {}, type:, &block)
      if destroy?
        super { redirect_to applications_path }
      elsif success_create?(type)
        super { render_ajax_redirect application_path(locals[:application]) }
      else
        super
      end
    end


    def render_message(message, type, locals = {})
      self.render_flash_message = success_create?(type)
      super
    end


    def add_breadcrumbs(action: action_name)
      label, url =
        case action
        when 'index'
          [Application.model_name.human(count: 2), '#']
        when 'show'
          [@application.fullname, application_path(@application)]
        when 'new', 'create'
          [t('.title'), '#']
        end
      add_breadcrumb label, 'fa-desktop', url
    end

end
