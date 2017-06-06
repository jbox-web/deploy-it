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

class MyController < DCIController

  include DCI::Controllers::Account
  set_dci_role 'DCI::Roles::AccountManager'

  before_action :set_user
  set_sidebar_menu :my


  def account
    add_breadcrumb t('.title'), 'fa-user', ''
    if request.patch?
      set_dci_data({ user: [:firstname, :lastname, :email, :language, :time_zone] })
      call_dci_role(:update_account)
    end
  end


  def reset_api_key
    call_dci_role(:reset_api_key) if request.patch?
  end


  def notifications
    render json: @user.subscribed_channels
  end


  private


    def set_user
      @user = User.current
    end

end
