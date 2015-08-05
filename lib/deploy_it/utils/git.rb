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

module DeployIt
  module Utils
    module Git
      extend self

      def parse_repository_from_ssh_command
        ENV['SSH_ORIGINAL_COMMAND'].split(' ')[1].gsub!("'", '').gsub!('.git', '')
      end


      def parse_git_command_from_ssh_command
        ENV['SSH_ORIGINAL_COMMAND'].split(' ')[0]
      end


      def ref_is_valid?(local_ref)
        while data = $stdin.gets
          old_revision, new_revision, pushed_ref = data.chomp.split(" ")
          if pushed_ref == local_ref
            valid = true
          else
            valid = false
          end
        end
        return valid, { old_revision: old_revision, new_revision: new_revision, ref_name: pushed_ref }
      end

    end
  end
end
