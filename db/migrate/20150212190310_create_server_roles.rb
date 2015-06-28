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

class CreateServerRoles < ActiveRecord::Migration
  def change
    create_table :server_roles do |t|
      t.integer  :platform_id
      t.integer  :server_id
      t.string   :name
      t.string   :daemon_path
      t.string   :alternative_host,   default: ''
      t.integer  :port
      t.integer  :connection_timeout, default: 10
      t.boolean  :default_server,     default: false

      t.timestamps null: false
    end

    add_index :server_roles, :platform_id
    add_index :server_roles, :server_id
    add_index :server_roles, :name
    add_index :server_roles, [:server_id, :name], unique: true
  end
end
