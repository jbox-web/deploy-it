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

class ApplicationsController < DCIController

  layout 'docker_app'

  set_dci_role 'DCI::Roles::ApplicationManager'

  before_action :set_application,  except: [:index, :new, :create]
  before_action :authorize,        except: [:index, :new, :create, :pushes, :releases]
  before_action :authorize_global, only:   [:new, :create]
  before_action :load_wizard_form, only:   [:new, :create]
  before_action :add_global_crumb, only:   [:show, :containers, :repositories, :activities, :events]


  def index
    add_breadcrumb Application.model_name.human(count: 2), 'fa-desktop', ''
    @applications = Application.visible(current_user).includes(:stage, :database, :containers).sorted_by_fullname
    render layout: 'application'
  end


  def show
    add_breadcrumb t('.title'), 'fa-info-circle', ''
    render_multi_responses(locals: { application: @application })
  end


  def new
    add_breadcrumb t('.title'), 'fa-desktop', ''
    self.render_flash_message = false
    render layout: 'application', locals: { application: @wizard_form.object }
  end


  def edit
    render_404
  end


  def create
    add_breadcrumb t('.title'), 'fa-desktop', ''
    self.render_flash_message = false
    call_dci_role(:create, @wizard_form, current_user)
  end


  def destroy
    call_dci_role(:destroy, @application)
  end


  def containers
    add_breadcrumb get_model_name_for('Container'), 'fa-rocket', ''
    render_multi_responses(locals: { application: @application })
  end


  def repositories
    add_breadcrumb t('.title'), 'fa-code', ''
    smart_listing_create(:releases, @application.releases.includes(build: [:push]), partial: 'applications/show/releases', default_sort: { created_at: 'desc' })
    render_multi_responses(locals: { application: @application })
  end


  def activities
    add_breadcrumb t('.title'), 'fa-clock-o', ''
    render_multi_responses(locals: { application: @application })
  end


  def events
    add_breadcrumb t('.title'), 'fa-commenting', ''
    render_multi_responses(locals: { application: @application })
  end


  private


    def load_wizard_form
      @wizard_form = ApplicationCreationWizardForm.new(Application, session, params.to_unsafe_h)
      if action_name.in? %w[new]
        @wizard_form.start
      elsif action_name.in? %w[create]
        @wizard_form.process
      end
    end


    def render_dci_response(template:, type:, locals: {}, &block)
      if destroy_action?
        super { redirect_to applications_path }
      elsif success_create?(type)
        super { render_ajax_redirect application_path(locals[:application]) }
      else
        super
      end
    end


    def render_message(message:, type:, locals: {}, errors: [])
      self.render_flash_message = success_create?(type)
      super
    end

end
