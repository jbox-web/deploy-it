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

module DCI
  module Roles
    class UserMembershipManager < Base

      def create_membership(user, params = {})
        if !params[:application_id].blank?
          application = Application.find(params[:application_id])
          member = Member.new(role_ids: params[:role_ids], enrolable_type: 'User', enrolable_id: user.id)
          application.members << member
        end
        context.render_success(locals: { user: user, member: member })
      end


      def update_membership(user, member, params = {})
        member.role_ids = params[:role_ids]
        member.save!
        context.render_success(locals: { user: user, member: member })
      end


      def destroy_membership(user, member, params = {})
        member.destroy if member.deletable?
        context.render_success(locals: { user: user })
      end

    end
  end
end
