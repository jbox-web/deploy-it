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
      # Devise stuff
      before_action :configure_permitted_parameters, if: :devise_controller?
    end


    protected


      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:login, keys: [:email, :password, :remember_me])
        devise_parameter_sanitizer.permit(:account_update, keys: [:current_password, :password, :password_confirmation])
        # devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
      end

  end
end
