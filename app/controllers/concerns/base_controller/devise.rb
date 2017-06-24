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
  module Devise
    extend ActiveSupport::Concern

    included do
      # This is a 'closed' application, be sure that visitors are logged in.
      before_action :require_login

      # Devise stuff
      before_action :configure_permitted_parameters, if: :devise_controller?
    end


    # This method is a more explicit shortcut for Devise #authenticate_user! method.
    # See https://github.com/plataformatec/devise for more infos.
    def require_login
      authenticate_user!
    end


    # This method is called in the Admin section of the application.
    # First we need to check if the visitor is logged.
    # If not, Devise will authenticate the user and will redirect him
    # to the desired page in the Admin section.
    # At that time this method will be triggered a second time and then
    # we will check if the visitor has the rights to access to the Admin section.
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


    protected


      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:login, keys: [:email, :password, :remember_me])
        devise_parameter_sanitizer.permit(:account_update, keys: [:current_password, :password, :password_confirmation])
        # devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
      end

  end
end
