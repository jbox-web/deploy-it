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

class MembersController < DCIController

  set_dci_role 'DCI::Roles::ApplicationMembershipManager'

  before_action :set_application
  before_action :authorize
  before_action :set_member, only: [:update, :destroy]


  def create
    set_dci_data({ member: { user_ids: [], group_ids: [], role_ids: [] } })
    call_dci_role(:add_members)
  end


  def update
    set_dci_data({ member: { user_ids: [], group_ids: [], role_ids: [] } })
    call_dci_role(:update_member, @member)
  end


  def destroy
    call_dci_role(:delete_member, @member) if request.delete?
  end


  private


    def set_application
      set_application_by(params[:application_id])
    end


    def set_member
      set_member_by(params[:id])
    end

end
