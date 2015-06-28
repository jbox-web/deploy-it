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

class CreateEnvVars < ActiveRecord::Migration
  def change
    create_table :env_vars do |t|
      t.integer :application_id
      t.string  :key
      t.string  :value
      t.string  :step
      t.boolean :protected, default: false

      t.timestamps null: false
    end

    add_index :env_vars, :application_id
    add_index :env_vars, [ :application_id, :key ], unique: true
  end
end
