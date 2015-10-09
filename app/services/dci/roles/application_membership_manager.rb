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
    class ApplicationMembershipManager < Base

      include ApplicationCommon


      def add_members(application, opts = {})
        members = []
        members += build_members('User', opts[:user_ids], opts[:role_ids])
        members += build_members('Group', opts[:group_ids], opts[:role_ids])
        application.members << members
        context.render_success(locals: { application: application, member_ids: members.map(&:id) })
      end


      def update_member(application, member, opts = {})
        member.role_ids = opts[:role_ids]
        member.save
        context.render_success(locals: { application: application, member: member })
      end


      def delete_member(application, member, opts = {})
        member.destroy if member.deletable?
        context.render_success(locals: { application: application })
      end


      private


        def build_members(type, list_ids = [], role_ids = [])
          list_ids.select { |id| !id.empty? }.map{ |id| build_member(id, type, role_ids) }
        end


        def build_member(id, type, role_ids = [])
          Member.new(enrolable_id: id, enrolable_type: type, role_ids: role_ids)
        end

    end
  end
end
