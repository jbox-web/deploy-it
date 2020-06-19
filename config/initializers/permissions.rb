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

# Permissions
DeployIt::AccessControl.map do |map|
  map.permission :view_application,    { applications: [:show, :repositories, :containers, :activities, :events],
                                         applications_manager: [:status],
                                         charts: [:charts]
                                        }, require: :loggedin
  map.permission :create_application,  { applications: [:new, :create] }, require: :loggedin
  map.permission :edit_application,    {
                                          applications_config: [
                                            :settings,
                                            :repository,
                                            :credentials,
                                            :env_vars,
                                            :mount_points,
                                            :addons,
                                            :ssl_certificate,
                                            :domain_names,
                                            :database,
                                            :synchronize_repository,
                                            :restore_env_vars,
                                            :restore_mount_points,
                                            :reset_database,
                                            :reset_ssl_certificate,
                                            :add_addon,
                                            :toggle_credentials,
                                            :toggle_ssl
                                          ]
                                        }, require: :member

  map.permission :delete_application,  { applications: [:destroy] },                 require: :member
  map.permission :build_application,   { applications_manager: [:build, :toolbar] }, require: :member

  map.permission :manage_application,  { applications_manager: [:manage], containers_manager: [:manage] }, require: :member

  map.permission :manage_members,      { members: [:index, :create, :edit, :update, :destroy] }, require: :member

  map.permission :create_credential,   { credentials: [:new, :create] },  require: :loggedin
  map.permission :edit_credential,     { credentials: [:edit, :update] }, require: :loggedin
  map.permission :delete_credential,   { credentials: [:destroy] },       require: :loggedin
end
