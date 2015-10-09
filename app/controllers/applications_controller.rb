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

class ApplicationsController < ApplicationController

  before_action :set_application,  except: [:index, :new, :create]
  before_action :authorize,        except: [:index, :new, :create]
  before_action :authorize_global, only:   [:new, :create]
  before_action :load_wizard_form, only:   [:new, :create]


  def index
    @applications = Application.visible.all
    add_crumb label_with_icon(Application.model_name.human(count: 2), 'fa-desktop', fixed: true), '#'
  end


  def show
    add_crumb label_with_icon(@application.fullname, 'fa-desktop', fixed: true), application_path(@application)
  end


  def new
    @application = @wizard_form.object
    add_crumb label_with_icon(t('.title'), 'fa-desktop', fixed: true), '#'
    render :new, locals: { application: @application }
  end


  def edit
    render_404
  end


  def create
    DCI::Roles::ApplicationManager.new(self).create(@wizard_form, User.current)
  end


  def destroy
    DCI::Roles::ApplicationManager.new(self).destroy(@application)
  end


  def infos
    render_ajax_response(locals: { application: @application })
  end


  def containers
    render_ajax_response(locals: { application: @application })
  end


  def repositories
    render_ajax_response(locals: { application: @application })
  end


  def status
    render_ajax_response(locals: { application: @application })
  end


  def toolbar
    render_ajax_response(locals: { application: @application })
  end


  def render_create_success(application)
    render_ajax_redirect application_path(application)
  end


  def render_create_failed(locals: {})
    add_crumb label_with_icon(t('.title'), 'fa-desktop', fixed: true), '#'
    render_ajax_response(locals: locals)
  end


  def render_destroy_success
    redirect_to applications_path
  end


  private


    def set_application
      @application = Application.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def load_wizard_form
      @wizard_form = ApplicationCreationWizardForm.new(Application, session, params)
      if action_name.in? %w[new]
        @wizard_form.start
      elsif action_name.in? %w[create]
        @wizard_form.process
      end
    end

end
