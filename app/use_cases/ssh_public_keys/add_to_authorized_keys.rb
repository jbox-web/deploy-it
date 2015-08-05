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

module SshPublicKeys
  class AddToAuthorizedKeys < ActiveUseCase::Base

    def execute(opts = {})
      if !ssh_public_key.exists_in_authorized_key_file?
        begin
          File.open(SshPublicKey.authorized_key_file, 'a') { |f| f.write(ssh_config + "\n") }
        rescue Errno::ENOENT => e
          File.open(SshPublicKey.authorized_key_file, 'w') { |f| f.write(ssh_config + "\n") }
        rescue => e
          error_message('Error while creating SSH Key!')
          log_exception(e)
        end
      end
    end


    private


      def ssh_config
        [ssh_directives.join(',').strip, ssh_public_key.key ].join(' ').strip
      end


      def ssh_directives
        [
          "no-agent-forwarding",
          "no-port-forwarding",
          "no-X11-forwarding",
          "no-pty",
          "no-user-rc",
          "command=\"#{script_path} #{ssh_public_key.owner} #{ssh_public_key.fingerprint}\""
        ]
      end


      def script_path
        Rails.root.join('wrappers', 'deploy-it-authentifier')
      end

  end
end
