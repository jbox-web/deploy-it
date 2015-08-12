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

module SshPublicKeys
  class RemoveFromAuthorizedKeys < ActiveUseCase::Base

    def execute(opts = {})
      if ssh_public_key.exists_in_authorized_key_file?
        output_file = Tempfile.new('ssh_config')
        File.open(SshPublicKey.authorized_key_file, 'r') do |f|
          f.each_line { |line| output_file.write line unless /#{ssh_public_key.fingerprint}/.match(line) }
        end
        output_file.close
        FileUtils.mv(output_file, SshPublicKey.authorized_key_file)
        File.chmod(0644, SshPublicKey.authorized_key_file)
      end
    rescue Errno::EACCES => e
      log_exception(e)
      error_message(tt('errors.unwriteable'))
    rescue => e
      log_exception(e)
      error_message(tt('errors.unknown'))
    end

  end
end
