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

class Admin::ApplicationTypesController < Admin::DefaultController

  include Crudify::Base

  crudify 'application_type',
          namespace: 'admin',
          crumbable: true,
          crumbs_opts: { icon: 'fa-desktop' },
          params: {
            on_create: [:name, :version, :language, :json_attributes],
            on_update: [:name, :version, :language, :json_attributes]
          }


  def index
    @application_types = ApplicationType.by_name_and_version
    add_breadcrumbs
  end


  def clone
    @application_type = ApplicationType.clone_from(params[:id])
    add_breadcrumbs_for(:new)
    render :new
  end

end
