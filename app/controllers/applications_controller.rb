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

  before_action :set_deployment_action, only: [:manage]


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
  end


  def edit
    render_404
  end


  def create
    @application = @wizard_form.object
    if @wizard_form.save
      # Call service objects to perform other actions
      call_service_objects
      render_ajax_redirect application_path(@application)
    else
      add_crumb label_with_icon(t('.title'), 'fa-desktop', fixed: true), '#'
      render_ajax_response
    end
  end


  def update
    # Call service objects to perform other actions
    call_service_objects if @application.update(application_update_params)
    render_ajax_response
  end


  def destroy
    @application.marked_for_deletion = true
    @application.save!
    # Call service objects to perform other actions
    call_service_objects
    redirect_to applications_path
  end


  def clone
    @application = Application.clone_from(params[:id])
    render 'new'
  end


  def infos
    render_ajax_response
  end


  def containers
    render_ajax_response
  end


  def repositories
    render_ajax_response
  end


  def status
    render_ajax_response
  end


  def toolbar
    render_ajax_response
  end


  def manage
    @application.run_async!(@deploy_action.to_method, event_options: event_options)
    render_ajax_response
  end


  def build
    push = @application.pushes.last
    if !push.nil?
      # Create build request
      build = @application.create_build_request!(push, User.current)
      @request_id = build.request_id

      # Call the BuildManager
      task = BuildManager.new(build, logger: 'console_streamer', event_options: event_options, user: User.current)

      if task.runnable?
        task.run!
      else
        flash[:error] = task.errors
      end
    else
      flash[:error] = t('label.application.unbuildable')
    end

    render_ajax_response
  end


  private


    def set_application
      @application = Application.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def set_deployment_action
      @deploy_action = @application.find_active_use_case(params[:deploy_action])
    rescue UseCaseNotDefinedError => e
      render_403
    end


    def application_update_params
      params.require(:application).permit(:name, :domain_name, :application_type_id, :instance_number, :image_type, :buildpack, :use_credentials, :use_cron, :use_ssl, :debug_mode)
    end


    def load_wizard_form
      @wizard_form = ApplicationCreationWizardForm.new(Application, session, params)
      if self.action_name.in? %w[new]
        @wizard_form.start
      elsif self.action_name.in? %w[create]
        @wizard_form.process
      end
    end


    def call_service_objects
      case self.action_name
      when 'create'
        @application.create_relations!
        @application.run_async!('bootstrap!')
      when 'update'
        @application.run_async!('update_files!')
        @application.update_lb_route! if @application.domain_name_has_changed? || @application.use_credentials_has_changed?
      when 'destroy'
        @application.run_async!('destroy_forever!')
      end
    end


    def event_options
      RefreshViewEvent.create(app_id: @application.id, triggers: triggers)
    end


    def triggers
      [toolbar_application_path(@application), status_application_path(@application)]
    end

end
