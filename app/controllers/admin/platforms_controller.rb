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

class Admin::PlatformsController < Admin::DefaultController

  include Crudify::Base

  crudify 'platform',
          namespace: 'admin',
          crumbable: true,
          crumbs_opts: { icon: 'fa-sitemap' },
          params: {
            on_create: [:name, :identifier],
            on_update: [:name, :identifier]
          }

  skip_before_action :require_admin, only: :stages


  def index
    @platforms = Platform.includes(:stages, :servers).all
    breadcrumbs_for_index
  end


  def create
    @platform = Platform.new(create_platform_params)

    breadcrumbs_for_create

    if @platform.save
      # Generate a PlatformCredential
      create_platform_credential
      successful_create
    else
      failed_create
    end
  end


  def stages
    @stages = @platform.stages.by_name
  end


  private


    def create_platform_credential
      data = DeployIt::Utils::Ssh.generate_ssh_key
      @platform.create_credential(public_key: data[:public_key], private_key: data[:private_key])
    end

end
