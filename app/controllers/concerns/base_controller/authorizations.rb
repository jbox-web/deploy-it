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

module BaseController
  module Authorizations
    extend ActiveSupport::Concern

    included do
      before_action :require_login
    end


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
      User.current.allowed_to?({ controller: ctrl, action: action }, @application || @applications, global: global) ? true : deny_access
    end


    # Authorize the user for the requested action outside an application
    def authorize_global(ctrl = params[:controller], action = params[:action], global = true)
      authorize(ctrl, action, global)
    end


    def render_403(opts = {})
      @application = nil
      render_4xx_error({ message: t('errors.not_authorized'), status: 403 }.merge(opts))
      return false
    end


    def render_404(opts = {})
      render_4xx_error({ message: t('errors.file_not_found'), status: 404 }.merge(opts))
      return false
    end


    # Renders an error response
    def render_4xx_error(arg)
      arg = { message: arg } unless arg.is_a?(Hash)

      @message = arg[:message]
      @status  = arg[:status] || 500

      respond_to do |format|
        format.html { render template: 'common/error', layout: error_layout, status: @status }
        format.any { head @status }
      end
    end


    def error_layout
      request.xhr? ? false : 'base'
    end

  end
end
