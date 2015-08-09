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

class MyController < ApplicationController

  def account
    @user = User.current
    if request.patch?
      if @user.update(user_params)
        # Locales may have changed, reset them before redirect
        reload_user_locales
        redirect_to my_account_path, notice: t('notice.profile.updated')
        return
      end
    end
  end


  def notifications
    render json: User.current.subscribed_channels
  end


  def reset_api_key
    @user = User.current
    if request.patch?
      @user.authentication_token = DeployIt::Utils.generate_secret(42)
      @user.save!
    end
  end


  private


    def user_params
      params.require(:user).permit(:firstname, :lastname, :email, :language, :time_zone)
    end

end
