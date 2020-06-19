# frozen_string_literal: true
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

class Admin::RolesController < Admin::DefaultController

  include Crudify::Base

  crudify 'role',
          namespace: 'admin',
          crumbable: true,
          crumbs_opts: { icon: 'fa-database' },
          params: {
            on_create: [:name, permissions: []],
            on_update: [:name, permissions: []]
          }


  def index
    @roles = Role.sorted
    add_breadcrumbs
  end


  def permissions
    @roles = Role.sorted
    @permissions = DeployIt::AccessControl.permissions.select { |p| !p.public? }

    add_breadcrumbs_for(:index)
    add_crumb t('.permissions_report'), '#'

    if request.post?
      @roles.each do |role|
        role.permissions = params[:permissions][role.id.to_s]
        role.save!
      end
      successful_update
    end
  end


  def sort
    params[:role].each_with_index do |id, index|
      Role.where(id: id).update_all({position: index+1})
    end
    render nothing: true
  end

end
