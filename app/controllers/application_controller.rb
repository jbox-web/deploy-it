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

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception

  # Secure Headers stuff
  ensure_security_headers

  # Devise stuff
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :setup_user
  before_action :setup_locale

  # Set TimeZone for current user
  # Must be in a around_action : Time.zone is NOT request local
  # http://railscasts.com/episodes/106-time-zones-revised?view=comments#comment_162005
  around_action :set_time_zone

  before_action :require_login


  # Module to render label
  include Labelable

  ## Will paginate gem
  require 'will_paginate/array'


  def setup_user
    User.current = current_user
  end


  def setup_locale
    I18n.locale = User.current.language || I18n.default_locale
  end


  # Error rendering
  def use_layout
    request.xhr? ? false : 'application'
  end


  def render_ajax_redirect(url)
    respond_to do |format|
      format.js { render js: "window.location = #{url.to_json};" }
    end
  end


  def render_ajax_response(template = self.action_name)
    respond_to do |format|
      format.js { render "#{get_controller_name}/ajax/#{template}" }
    end
  end


  def get_controller_name
    self.class.name.gsub('Controller', '').underscore
  end


  def render_403(opts = {})
    @application = nil
    render_error({ message: t('errors.not_authorized'), status: 403 }.merge(opts))
    return false
  end


  def render_404(opts = {})
    render_error({ message: t('errors.file_not_found'), status: 404 }.merge(opts))
    return false
  end


  # Renders an error response
  def render_error(arg)
    arg = { message: arg } unless arg.is_a?(Hash)

    @message = arg[:message]
    @status  = arg[:status] || 500

    respond_to do |format|
      format.html { render template: 'common/error', layout: use_layout, status: @status }
      format.any { head @status }
    end
  end


  # Call by other controllers
  def require_login
    authenticate_user!
  end


  def require_admin
    return unless require_login
    render_403 if !User.current.admin?
  end


  def deny_access
    User.current.logged? ? render_403 : require_login
  end


  # Authorize the user for the requested action
  def authorize(ctrl = params[:controller], action = params[:action], global = false)
    allowed = User.current.allowed_to?({ controller: ctrl, action: action }, @application || @applications, global: global)
    if allowed
      true
    else
      deny_access
    end
  end


  # Authorize the user for the requested action outside an application
  def authorize_global(ctrl = params[:controller], action = params[:action], global = true)
    authorize(ctrl, action, global)
  end


  def async_containers_toolbar_view_refresh(opts = {})
    {
      context: {
        controller: 'applications',
        action: 'show',
        app_id: @application.id
      },
      triggers: [
        "refreshView('#{toolbar_application_path(@application)}');",
        "refreshView('#{status_application_path(@application)}');"
      ]
    }
  end


  def async_repositories_view_refresh(opts = {})
    {
      context: {
        controller: 'applications',
        action: 'show',
        app_id: @application.id
      },
      triggers: [
        "refreshView('#{repositories_application_path(@application)}');"
      ]
    }
  end


  def async_applications_list_view_refresh(opts = {})
    {
      context: {
        controller: 'admin/applications',
        action: 'index',
        app_id: ''
      },
      triggers: [
        "refreshView('#{admin_application_status_path(opts[:app_id], opts)}')"
      ]
    }
  end


  def async_view_refresh(view, opts = {})
   method = "async_#{view}_view_refresh"
   self.send(method, opts)
  end


  protected


    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:login) { |u| u.permit(:email, :password, :remember_me) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:current_password, :password, :password_confirmation) }
      # devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation) }
    end


    def reload_user_locales
      User.current.reload
      setup_locale
    end


    def set_time_zone(&block)
      Time.use_zone(User.current.time_zone, &block)
    end

end
