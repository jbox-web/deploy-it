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

module Containers
  class DestroyForever < ActiveUseCase::Base

    def execute(opts = {})
      self_destroy = opts.delete(:self_destroy){ true }
      if container.docker_id
        begin
          # Stop it first
          container.docker_stop
        rescue => e
          log_exception(e)
          error_message(e.message)
        ensure
          begin
            container.docker_delete
          rescue => e
            log_exception(e)
            error_message("Erreurs lors de la suppression du contenaire '#{container.docker_id}'")
          ensure
            container.destroy! if self_destroy
          end
        end
      else
        error_message("Container does not exist !.")
      end
    end

  end
end
