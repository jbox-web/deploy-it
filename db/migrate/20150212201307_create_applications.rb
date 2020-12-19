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

class CreateApplications < ActiveRecord::Migration[4.2]
  def change
    create_table :applications do |t|
      t.integer :application_type_id
      t.integer :stage_id
      t.string  :name
      t.string  :identifier, limit: 13
      t.string  :deploy_url
      t.string  :domain_name
      t.string  :image_type
      t.string  :buildpack
      t.integer :instance_number,     default: 1
      t.boolean :use_cron,            default: false
      t.boolean :use_ssl,             default: false
      t.boolean :debug_mode,          default: false
      t.boolean :marked_for_deletion, default: false
      t.text    :description

      t.timestamps null: false
    end

    add_index :applications, [:identifier, :stage_id], unique: true
    add_index :applications, :deploy_url, unique: true

    add_index :applications, :application_type_id
    add_index :applications, :stage_id
  end
end
