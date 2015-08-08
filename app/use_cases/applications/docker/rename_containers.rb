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
  module Docker
    class RenameContainers < ActiveUseCase::Base

      def execute(type:, version:)
        scope = "type_#{type}"
        application.containers.send(scope).each_with_index do |container, index|
          new_name = "#{application.fullname_with_dashes}_v#{version}.#{type}.#{index + 1}"
          begin
            container.docker_proxy.rename(new_name)
          rescue => e
            log_exception(e)
            error_message(e.message)
          else
            result = container.restart!
            @errors += result.errors if !result.success?
          end
        end
      end

    end
  end
end
