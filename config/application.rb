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

require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DeployIt
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/plugins)

    # ActiveRecord config
    config.active_record.store_full_sti_class = true

    # Locales
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]
    config.i18n.default_locale = :fr
    config.i18n.available_locales = [:en, :fr]

    # Timezone
    config.time_zone = 'Paris'

    # Log Level
    config.log_level = :info

    # Generators
    config.generators do |g|
      g.orm            :active_record
      g.test_framework :rspec
    end

    # ActiveJob config
    config.active_job.queue_adapter = :sidekiq

    # https://github.com/plataformatec/devise/issues/3643
    config.relative_url_root = '/'

    # Cache store
    config.cache_store = :redis_store, { host:       ENV['REDIS_HOST'],
                                         port:       ENV['REDIS_PORT'],
                                         db:         ENV['REDIS_DB'],
                                         namespace:  'cache',
                                         driver:     :hiredis,
                                         expires_in: 90.minutes }

    # Logster
    Logster.store = Logster::RedisStore.new Redis.new(host:      ENV['REDIS_HOST'],
                                                      port:      ENV['REDIS_PORT'],
                                                      db:        ENV['REDIS_DB'],
                                                      namespace: 'logster',
                                                      driver:    :hiredis)
  end
end

# https://github.com/rails/rails/issues/19880
Figaro.load
