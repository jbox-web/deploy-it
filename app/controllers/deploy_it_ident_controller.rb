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

class DeployItIdentController < ApplicationController

  protect_from_forgery except: :index
  skip_before_action :require_login

  before_action :authenticate_request


  def index
    render text: compute_authorized_keys
  end


  private


    def authenticate_request
      auth_token = params[:auth_token] || ''
      return render text: '' if auth_token.empty? || auth_token != Settings.authentication_token
    end


    def compute_authorized_keys
      SshPublicKey.all.map { |k| k.ssh_command(script_path) }.join("\n")
    end


    def script_path
      File.join(Settings.scripts_path, 'deploy-it-authentifier')
    end

end
