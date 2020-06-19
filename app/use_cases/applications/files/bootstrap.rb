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
    class Bootstrap < ActiveUseCase::Base

      def execute(opts = {})
        # Clone application repository!
        result = application.distant_repo.clone!
        @errors += result.errors if !result.success?

        # Init application repository!
        result = application.local_repo.init_bare!
        @errors += result.errors if !result.success?

        # Create files
        result = application.update_files!
        @errors += result.errors if !result.success?

        # Create database
        result = application.create_physical_database!
        @errors += result.errors if !result.success?
      end

    end
  end
end
