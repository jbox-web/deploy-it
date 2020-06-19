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

require 'fileutils'

module ActsAs
  module RuggedRepository
    extend ActiveSupport::Concern

    def local_branch
      "refs/heads/#{branch}"
    end


    def rugged_proxy
      @rugged_proxy ||= RuggedProxy.new(path, branch, credentials_options)
    end


    def credentials_options
      if credential.nil?
        {}
      elsif credential.is_a?(RepositoryCredential::SshKey)
        { type: :ssh_key, username: username, public_key: credential.public_key, private_key: credential.private_key }
      elsif credential.is_a?(RepositoryCredential::BasicAuth)
        { type: :basic_auth, login: credential.login, password: credential.password }
      end
    end

  end
end
