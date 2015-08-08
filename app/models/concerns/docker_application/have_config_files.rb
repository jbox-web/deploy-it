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

module DockerApplication
  module HaveConfigFiles
    extend ActiveSupport::Concern

    def env_file_for(step)
      case step
      when :build
        File.join(local_repo.path, 'BUILD_ENV').to_s
      when :deploy
        File.join(local_repo.path, 'ENV').to_s
      when :database
        File.join(local_repo.path, 'DATABASE').to_s
      end
    end


    def env_vars_for(step)
      case step
      when :build, :deploy
        active_env_vars.to_env.map { |var| "export #{var}" }.join("\n")
      when :database
        database_params.to_env.map { |var| "export #{var}" }.join("\n")
      end
    end

  end
end
