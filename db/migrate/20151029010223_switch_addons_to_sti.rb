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

class SwitchAddonsToSti < ActiveRecord::Migration[4.2]
  def up
    remove_index  :application_addons, name: 'index_application_addons_on_application_id_and_addon_id'
    remove_column :application_addons, :addon_id
    add_column    :application_addons, :type, :string, after: :application_id
    add_index     :application_addons, [:application_id, :type], unique: true
    drop_table    :addons
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
