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

require 'net/ssh'
require 'sshkey'

module DeployIt
  module Utils
    module Ssh
      extend self

      def fingerprint(key)
        SSHKey.fingerprint(key)
      rescue => e
        nil
      end


      def valid_ssh_private_key?(key)
        k = SSHKey.new(key)
      rescue => e
        false
      end


      def valid_ssh_public_key?(key)
        SSHKey.valid_ssh_public_key?(key)
      end


      def generate_ssh_key
        key = SSHKey.generate(comment: "deploy-it@#{Settings.access_domain_name}")
        { generated: true, private_key: key.private_key, public_key: key.ssh_public_key }
      end


      def execute_ssh_command(host, user, command, opts = {})
        Net::SSH.start(host, user, opts) do |ssh|
          ssh.exec!(command)
        end
      end

    end
  end
end
