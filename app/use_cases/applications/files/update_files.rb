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

module Applications
  module Files
    class UpdateFiles < ActiveUseCase::Base

      def execute(opts = {})
        update_file application.env_file_for(:build),    application.env_vars_for(:build)
        update_file application.env_file_for(:deploy),   application.env_vars_for(:deploy)
        update_file application.env_file_for(:database), application.env_vars_for(:database)
      end


      def update_file(file, content)
        File.delete(file) if File.exists?(file)
        begin
          new_file = File.open(file, 'w')
          new_file.write content + "\n"
          new_file.close
        rescue => e
          error_message('Error while creating Application config files!')
          log_exception(e)
        end
      end

    end
  end
end
