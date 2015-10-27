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

class Authentifier

  attr_reader :token
  attr_reader :fingerprint
  attr_reader :user
  attr_reader :ssh_key
  attr_reader :errors


  def initialize(token, fingerprint)
    @token       = token
    @fingerprint = fingerprint
    @user        = nil
    @ssh_key     = nil
    @errors      = []

    find_user
    find_fingerprint
  end


  def passed?
    if !user.nil? && !ssh_key.nil?
      true
    else
      @errors << I18n.t('errors.deploy_it.account_not_found')
      @errors << I18n.t('errors.deploy_it.subscribe')
      false
    end
  end


  private


    def find_user
      @user = User.find_by_authentication_token(token)
    end


    def find_fingerprint
      @ssh_key = user.ssh_public_keys.find_by_fingerprint(fingerprint) unless user.nil?
    end

end
