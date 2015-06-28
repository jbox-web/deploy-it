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

class CreateSshPublicKeys < ActiveRecord::Migration
  def change
    create_table :ssh_public_keys do |t|
      t.integer :user_id
      t.string  :title
      t.string  :fingerprint
      t.text    :key

      t.timestamps null: false
    end

    add_index :ssh_public_keys, :user_id
    add_index :ssh_public_keys, :fingerprint
  end
end
