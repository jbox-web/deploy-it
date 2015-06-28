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

    def empty?
      rugged_proxy.empty?
    end


    def syncable?
      rugged_proxy.syncable?
    end


    def synced?
      rugged_proxy.synced?
    end


    def rugged_errors
      rugged_proxy.errors
    end


    def commit_distance
      rugged_proxy.commit_distance
    end


    def local_branch
      rugged_proxy.local_branch
    end


    def remote_branch
      rugged_proxy.remote_branch
    end


    def last_commit(truncated = true)
      truncated ? rugged_proxy.last_commit[0..6] : rugged_proxy.last_commit
    end


    def last_commit_author_name
      rugged_proxy.last_commit_author_name
    end


    def last_commit_author_mail
      rugged_proxy.last_commit_author_mail
    end


    def last_commit_message
      rugged_proxy.last_commit_message
    end


    def last_commit_date
      rugged_proxy.last_commit_date
    end


    def pull_me!
      rugged_proxy.pull
    end


    def clone_me!
      rugged_proxy.clone_at(url)
    end


    def init_me!
      rugged_proxy.init_at
    end


    def archive_me!(revision = 'master')
      rugged_proxy.archive(revision)
    end


    private


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
