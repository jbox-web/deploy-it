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

module BaseController
  module Authorizations
    extend ActiveSupport::Concern

      def deny_access
        current_site_user.logged? ? render_403 : require_login
      end


      # Authorize the user for the requested action
      def authorize(ctrl = params[:controller], action = params[:action], global = false)
        current_site_user.allowed_to?({ controller: ctrl, action: action }, @application || @applications, global: global) ? true : deny_access
      end


      # Authorize the user for the requested action outside an application
      def authorize_global(ctrl = params[:controller], action = params[:action], global = true)
        authorize(ctrl, action, global)
      end

  end
end
