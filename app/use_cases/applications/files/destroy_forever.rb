# frozen_string_literal: true
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
    class DestroyForever < ActiveUseCase::Base

      def execute(opts = {})
        # Destroy route
        log_message "Destroy application route : #{application.name}"
        application.destroy_lb_route!

        # Destroy associated containers
        log_message "Destroy application containers : #{application.name}"
        application.containers.each do |c|
          c.destroy_forever!(self_destroy: false)
        end

        # Destroy application's repositories
        log_message "Destroy application repository : #{application.name}"
        application.distant_repo.destroy_forever! if application.distant_repo
        application.local_repo.destroy_forever! if application.local_repo

        # Destroy application database
        log_message "Destroy application database : #{application.name}"
        application.destroy_physical_database! if application.database

        # Then destroy database object
        log_message "Destroy application : #{application.name}"
        @errors << application.errors.full_messages if !application.destroy
      end

    end
  end
end
