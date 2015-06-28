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

class CreateContainers < ActiveRecord::Migration
  def change
    create_table :containers do |t|
      t.integer :application_id
      t.integer :server_id
      t.integer :release_id
      t.string  :type
      t.integer :cpu_shares, default: 256
      t.integer :memory,     default: 256
      t.string  :docker_id
      t.boolean :marked_for_deletion, default: false

      t.timestamps null: false
    end

    add_index :containers, :application_id
    add_index :containers, :docker_id
  end
end
