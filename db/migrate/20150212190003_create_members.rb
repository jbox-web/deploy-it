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

class CreateMembers < ActiveRecord::Migration[4.2]
  def change
    create_table :members do |t|
      t.integer :enrolable_id
      t.string  :enrolable_type
      t.integer :application_id

      t.timestamps null: false
    end

    add_index :members, :enrolable_id
    add_index :members, :application_id
    add_index :members, [:enrolable_id, :enrolable_type, :application_id], name: :unique_member, unique: true
  end
end
