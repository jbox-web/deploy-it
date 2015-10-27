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

class Admin::MembershipsController < Admin::DCIController

  set_dci_role 'DCI::Roles::UserMembershipManager'
  self.render_flash_message = false

  before_action :set_user
  before_action :set_member, only: [:edit, :update, :destroy]


  def index
    set_smart_listing
  end


  def edit
  end


  def create
    set_dci_data({ membership: [:application_id, role_ids: []] })
    call_dci_role(:create_membership, @user)
  end


  def update
    set_dci_data({ membership: { role_ids: [] } })
    call_dci_role(:update_membership, @user, @member)
  end


  def destroy
    call_dci_role(:destroy_membership, @user, @member) if request.delete?
  end


  private


    def set_user
      set_user_by(params[:user_id])
    end


    def render_dci_response(template:, type:, locals: {}, &block)
      set_smart_listing
      super
    end


    def set_smart_listing
      smart_listing_create(:memberships, @user.memberships.includes(:application, :roles, :member_roles), partial: 'admin/memberships/listing')
    end

end
