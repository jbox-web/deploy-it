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

module Repositories
  class InitBare < ActiveUseCase::Base

    def execute
      init_repository if !repository.exists?
    end


    private


      def init_repository
        begin
          repository.init_me!
        rescue => e
          error_message("Error while initializing repository !")
          log_exception(e)
        else
          install_hook
        end
      end


      def install_hook
        begin
          file = File.open(hook_file_path, "w")
          file.write "#!/usr/bin/env bash\n"
          file.write "set -e; set -o pipefail;\n"
          file.write "cat | #{script_path} #{repository.application.deploy_url}\n"
          file.close
          File.chmod(0755, hook_file_path)
        rescue => e
          error_message("Error while installing hook !")
          log_exception(e)
        end
      end


      def hook_file_path
        File.join(repository.path, 'hooks', 'pre-receive')
      end


      def script_path
        File.join(Settings.scripts_path, 'deploy-it-builder')
      end

  end
end
