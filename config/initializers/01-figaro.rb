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

APPLICATION_CONFIG = {
  rails_config: %w(
    SECRET_KEY_BASE
    APPLICATION_NAME
  ),

  db_config: %w(
    DB_HOST
    DB_PORT
    DB_NAME
    DB_USER
    DB_PASS
  ),

  redis_config: %w(
    REDIS_HOST
    REDIS_PORT
    REDIS_DB
  ),

  app_config: %w(
    MAIL_FROM
    LOG_LEVEL
    ACCESS_URL
    FAYE_SECRET
    AUTHENTICATION_SERVER
    AUTHENTICATION_TOKEN
    WHITE_LISTED_IPS
    ACCESS_DOMAIN_NAME
    DOCKER_REGISTRY
    APPLICATIONS_CLONES_DIR
    APPLICATIONS_REPOS_DIR
    APPLICATIONS_DATAS_DIR
    SCRIPTS_PATH
  ),

  devise_config: %w(
    SESSION_TIMEOUT
  ),

  # smtp_config: %w(
  #   SMTP_HOST
  #   SMTP_PORT
  #   SMTP_DOMAIN
  #   SMTP_USER
  #   SMTP_PASS
  #   MAIL_FROM
  # ),

  monitoring_config: %w(
    MAIL_ON_APPLICATION_ERROR
  ),

}.freeze

begin
  Figaro.require_keys(*APPLICATION_CONFIG.values.flatten)
rescue Figaro::MissingKeys => e
  puts "\n#{e.message}"
  exit 1
end
