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
          File.open(SshPublicKey.authorized_key_file, 'a') { |f| f.write(ssh_public_key.ssh_command(script_path) + "\n") }
        rescue Errno::ENOENT => e
          File.open(SshPublicKey.authorized_key_file, 'w') { |f| f.write(ssh_public_key.ssh_command(script_path) + "\n") }
        rescue Errno::EACCES => e
          log_exception(e)
          error_message(tt('errors.unwriteable'))
        rescue => e
          log_exception(e)
          error_message(tt('errors.unknown'))
        end
      end
    end


    def script_path
      File.join(Settings.scripts_path, 'deploy-it-authentifier')
    end

  end
end
