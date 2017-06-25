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

require 'sidekiq/exception_handler'

#
# Configure Sidekiq/Redis
#

Sidekiq.configure_server do |config|
  config.redis = { host: Settings.redis_host, port: Settings.redis_port, db: Settings.redis_db, namespace: 'sidekiq', driver: :hiredis }
end

Sidekiq.configure_client do |config|
  config.redis = { host: Settings.redis_host, port: Settings.redis_port, db: Settings.redis_db, namespace: 'sidekiq', driver: :hiredis }
end

#
# Configure Sidekiq logger to redirect logs to Logster
# From https://github.com/discourse/discourse/blob/master/config/initializers/100-sidekiq.rb
#

if Rails.env.production?
  Sidekiq.logger = Syslogger.new("#{Settings.application_name}.worker", nil, Syslog::LOG_LOCAL7)
  Sidekiq.logger.level = Logger::WARN

  class SidekiqLogsterReporter < Sidekiq::ExceptionHandler::Logger
    def call(ex, context = {})
      # Pass context to Logster
      fake_env = {}
      context.each do |key, value|
        Logster.add_to_env(fake_env, key, value)
      end

      text = "Job exception: #{ex}\n"
      if ex.backtrace
        Logster.add_to_env(fake_env, :backtrace, ex.backtrace)
      end

      Logster.add_to_env(fake_env, :current_hostname, Settings.access_domain_name)

      Thread.current[Logster::Logger::LOGSTER_ENV] = fake_env
      Logster.logger.error(text)
    rescue => e
      Logster.logger.fatal("Failed to log exception #{ex} #{hash}\nReason: #{e.class} #{e}\n#{e.backtrace.join("\n")}")
    ensure
      Thread.current[Logster::Logger::LOGSTER_ENV] = nil
    end
  end

  Sidekiq.error_handlers.clear
  Sidekiq.error_handlers << SidekiqLogsterReporter.new
end
