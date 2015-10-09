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
  map.permission :view_application,    {
                                          applications: [:show],
                                          ajax: [:infos, :repositories, :containers, :status]
                                        }, require: :loggedin

  map.permission :create_application,  { applications: [:new, :create] }, require: :loggedin

  map.permission :edit_application,    {
                                          applications: [:edit, :update],
                                          applications_config: [:repository, :env_vars, :mount_points, :domain_names, :database]
                                        }, require: :member

  map.permission :delete_application,  { applications: [:destroy] },                 require: :member
  map.permission :build_application,   { applications: [:build], ajax: [:toolbar] }, require: :member

  map.permission :manage_application,  { applications: [:manage], containers: [:manage] }, require: :member
  map.permission :manage_members,      { members:      [:create, :update, :destroy] },     require: :member

  map.permission :create_credential,   { credentials: [:new, :create] },  require: :loggedin
  map.permission :edit_credential,     { credentials: [:edit, :update] }, require: :loggedin
  map.permission :delete_credential,   { credentials: [:destroy] },       require: :loggedin
end
