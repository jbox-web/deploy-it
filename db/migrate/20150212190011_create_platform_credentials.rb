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

class CreatePlatformCredentials < ActiveRecord::Migration
  def change
    create_table :platform_credentials do |t|
      t.integer :platform_id
      t.string  :fingerprint
      t.text    :public_key
      t.text    :private_key

      t.timestamps null: false
    end

    add_index :platform_credentials, :platform_id, unique: true
    add_index :platform_credentials, :fingerprint, unique: true
  end
end
