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

class Authorizer

  attr_reader :repo_name
  attr_reader :user
  attr_reader :application
  attr_reader :errors


  def initialize(repo_name, user)
    @repo_name   = repo_name
    @user        = user
    @application = nil
    @errors      = []
  end


  def passed?
    find_application && user_allowed?
  end


  private


    def find_application
      app = Application.find_by_repo_url(repo_name)
      if app.nil?
        @errors << I18n.t('errors.deploy_it.repository_not_found')
        @errors << I18n.t('errors.deploy_it.contact_your_admin')
        false
      else
        @application = app
        true
      end
    end


    def user_allowed?
      if user.allowed_to?(:build_application, application)
        true
      else
        @errors << I18n.t('errors.deploy_it.unauthorized')
        @errors << I18n.t('errors.deploy_it.contact_your_admin')
        false
      end
    end

end
