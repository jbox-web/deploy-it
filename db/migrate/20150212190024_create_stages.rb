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

class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.string  :name
      t.string  :identifier
      t.integer :platform_id
      t.string  :portal_url
      t.string  :database_name_prefix
      t.string  :domain_name_suffix
      t.text    :description

      t.timestamps null: false
    end

    add_index :stages, [:identifier, :platform_id], unique: true
    add_index :stages, :platform_id
  end
end
