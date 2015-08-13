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

    include Containers::Base


    def execute(opts = {})
      self_destroy = opts.delete(:self_destroy){ true }

      # Stop it first
      catch_errors(container, opts) do
        container.docker_proxy.stop
      end

      begin
        # Remove it from Docker
        container.docker_proxy.delete
      rescue => e
        log_exception(e)
        error_message(e.message)
      ensure
        # Remove from database
        container.destroy! if self_destroy
      end
    end

  end
end
