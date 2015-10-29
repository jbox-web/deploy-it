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

  MAX_INSTANCES_NUMBER = (1..4).to_a
  MAX_MEMORY_AVAILABLE = (128..1024).step(128).to_a

  AVAILABLE_LANGUAGES  = %w(php ruby python)
  AVAILABLE_DATABASES  = %w(mysql postgres)
  EXCLUDED_APP_NAME    = %w(mysql information_schema performance_schema)

  AVAILABLE_ADDONS     = {
    redis: {
      port: 6379,
      image: 'redis',
      url: 'https://hub.docker.com/_/redis/',
      start_command: ['redis-server']
    },
    memcached: {
      port: 11211,
      image: 'memcached',
      url: 'https://hub.docker.com/_/memcached/',
      start_command: ['memcached']
    }
  }

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
end

## Load Ruby Core patch and DeployIt Libs
required_lib_dirs = [
  Rails.root.join('lib', 'core_ext', '**', '*.rb'),
  Rails.root.join('lib', 'deploy_it', '**', '*.rb')
]

required_lib_dirs.each do |regex|
  Dir.glob(regex).each do |file|
    require file unless File.dirname(file).split('/').last == 'foreman'
  end
end

## Init logs
DeployIt.console_logger = DeployIt::Loggers::ConsoleLogs.new
DeployIt.file_logger    = DeployIt::Loggers::FileLogs.init_logs!

# Init Plugins
required_plugins_dirs = Rails.root.join('plugins', '**', '*.rb')
Dir.glob(required_plugins_dirs).each do |file|
  require file
end
