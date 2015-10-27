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
      @token       = params[:token]       || ''
      @fingerprint = params[:fingerprint] || ''
      @repo_name   = params[:repo_name]   || ''

      return render_error(t('errors.deploy_it.missing_param', param: 'token'))       if @token.empty?
      return render_error(t('errors.deploy_it.missing_param', param: 'fingerprint')) if @fingerprint.empty?
      return render_error(t('errors.deploy_it.missing_param', param: 'repo_name'))   if @repo_name.empty?
    end


    def authenticate_user
      # First authenticate user in Deployer
      authentication = Authentifier.new(@token, @fingerprint)
      return render_error(authentication.errors) if !authentication.passed?
      @user = authentication.user
    end


    def authorize_user
      # Then do authorization
      authorization = Authorizer.new(@repo_name, @user)
      return render_error(authorization.errors) if !authorization.passed?
      @application = authorization.application
    end


    def render_error(message)
      message = [message] if message.is_a?(String)
      render json: { auth: { passed: false, messages: message } }
    end

end
