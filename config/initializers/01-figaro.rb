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

RAILS_REQUIRED_KEYS = [
  'DB_ADAPTER',
  'DB_HOST',
  'DB_PORT',
  'DB_NAME',
  'DB_USER',
  'DB_PASS',
  'RAILS_SECRET'
]

DEPLOY_IT_REQUIRED_KEYS = [
  # Logs
  'LOG_LEVEL',

  # Redis (Sidekiq / Faye)
  'REDIS_HOST',
  'REDIS_PORT',

  # Faye server / Async events
  'ACCESS_URL',
  'FAYE_SECRET',

  # DeployIt authentication server
  'AUTHENTICATION_SERVER',
  'AUTHENTICATION_TOKEN',
  'WHITE_LISTED_IPS',

  # DeployIt domain name
  'ACCESS_DOMAIN_NAME',

  # Private Docker Registry
  'DOCKER_REGISTRY',

  # DeployIt directories
  'APPLICATIONS_CLONES_DIR',
  'APPLICATIONS_REPOS_DIR',
  'APPLICATIONS_DATAS_DIR',

  # Scripts path
  'SCRIPTS_PATH',

  # Registration mailer
  'MAIL_FROM'
]

FIGARO_REQUIRED_KEYS = RAILS_REQUIRED_KEYS + DEPLOY_IT_REQUIRED_KEYS

Figaro.require_keys(*FIGARO_REQUIRED_KEYS)
