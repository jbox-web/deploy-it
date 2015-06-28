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

  MAX_INSTANCES_NUMBER = 4
  AVAILABLE_LANGUAGES  = %w(php ruby python)
  AVAILABLE_DATABASES  = %w(mysql postgres)
  EXCLUDED_APP_NAME    = %w(mysql information_schema performance_schema)

  MANAGER_PERMS = [
    :view_application,
    :create_application,
    :edit_application,
    :delete_application,
    :build_application,
    :manage_application,
    :manage_members,
    :create_credential,
    :edit_credential,
    :delete_credential
  ]

  DEVELOPER_PERMS = [
    :view_application,
    :edit_application,
    :build_application,
    :manage_application
  ]

  class << self

    @@file_logger    = nil
    @@console_logger = nil

    def file_logger
      @@file_logger
    end

    def file_logger=(logger)
      @@file_logger = logger
    end

    def console_logger
      @@console_logger
    end

    def console_logger=(logger)
      @@console_logger = logger
    end

  end

  ## Ruby Core patch
  require_relative 'core_ext/hash/to_env'
  require_relative 'core_ext/string/quote'

  ## DeployIt Libs
  require_relative 'deploy_it/error'
  require_relative 'deploy_it/utils'
  require_relative 'deploy_it/ssh_utils'
  require_relative 'deploy_it/ssl_utils'

  require_relative 'deploy_it/loggers/async_logs'
  require_relative 'deploy_it/loggers/console_logs'
  require_relative 'deploy_it/loggers/file_logs'

  require_relative 'deploy_it/access_control'

  ## Init logs
  DeployIt.console_logger = Loggers::ConsoleLogs.new
  DeployIt.file_logger    = Loggers::FileLogs.init_logs!
  ActiveUseCase.logger    = DeployIt.file_logger

  ## Plugins
  Dir["#{Rails.root.join('plugins')}/*/*.rb"].each { |f| require f }
end
