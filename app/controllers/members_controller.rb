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

class MembersController < ApplicationController

  include DCI::Context

  before_action :set_application
  before_action :authorize

  before_action :set_member, only: [:update, :destroy]


  def create
    set_required_params({ member: { user_ids: [], group_ids: [], role_ids: [] } })
    call_context(:add_members)
  end


  def update
    set_required_params({ member: { user_ids: [], group_ids: [], role_ids: [] } })
    call_context(:update_member, @member)
  end


  def destroy
    if request.delete?
      set_required_params({ strong_params: false })
      call_context(:delete_member, @member)
    end
  end


  private


    def call_context(method, *args)
      DCI::Roles::ApplicationMembershipManager.new(self).send(method, @application, *args, get_required_params)
    end


    def set_application
      @application = Application.find(params[:application_id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def set_member
      @member = Member.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end

end
