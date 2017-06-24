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

  include DCI::Controllers::Application
  set_dci_role 'DCI::Roles::ApplicationMembershipManager'
  self.render_flash_message = false

  layout 'docker_app'

  before_action :set_application
  before_action :authorize
  before_action :set_member, only: [:edit, :update, :destroy]
  before_action :add_global_crumb


  def index
    set_smart_listing
  end


  def edit
  end


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


    def add_global_crumb
      super
      add_breadcrumb get_model_name_for('Member'), 'fa-users', ''
    end


    def render_dci_response(template:, type:, locals: {}, &block)
      set_smart_listing
      super
    end


    def set_smart_listing
      smart_listing_create(:members, @application.members.includes(:enrolable, :roles), partial: 'members/members')
    end

end
