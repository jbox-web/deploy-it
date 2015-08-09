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

class DeployItController < ApplicationController

  protect_from_forgery except: :auth
  skip_before_action :require_login

  before_action :find_params
  before_action :authenticate_user
  before_action :authorize_user


  def auth
    message = { auth: { passed: true, repo_path: @application.local_repo.path, user_id: @user.id } }
    render json: message
  end


  private


    def find_params
      email       = params[:email] || ''
      fingerprint = params[:fingerprint] || ''
      repo_name   = params[:repo_name] || ''

      if email.empty?
        render_error('Error! Missing params : email')
        return
      else
        @email = email
      end

      if fingerprint.empty?
        render_error('Error! Missing params : fingerprint')
        return
      else
        @fingerprint = fingerprint
      end

      if repo_name.empty?
        render_error('Error! Missing params : repo_name')
        return
      else
        @repo_name = repo_name
      end
    end


    def authenticate_user
      # First authenticate user in Deployer
      authentication = Authentifier.new(@email, @fingerprint)
      if !authentication.passed?
        render_error(["You don't have any account on this platform !", "Subscribe before : http://www.jbox-cloud.com"])
        return
      else
        @user = authentication.user
      end
    end


    def authorize_user
      # Then do authorization
      authorization = Authorizer.new(@repo_name, @user)
      if !authorization.passed?
        render_error(authorization.errors)
        return
      else
        @application = authorization.application
      end
    end


    def render_error(message)
      message = [message] if message.is_a?(String)
      render json: { auth: { passed: false, messages: message } }
    end

end
