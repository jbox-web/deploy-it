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

class MemberRole < ApplicationRecord

  ## Relations
  belongs_to :member
  belongs_to :role

  ## Basic Validations
  validates_presence_of :role

  ## Callbacks
  after_create  :add_role_to_group_users
  after_destroy :remove_member_if_empty, :remove_inherited_roles


  def inherited?
    !inherited_from.nil?
  end


  private


    def add_role_to_group_users
      if member.enrolable.is_a?(Group) && !inherited?
        member.enrolable.users.each do |user|
          user_member = Member.find_or_new(member.application_id, user.id)
          user_member.member_roles << MemberRole.new(role: role, inherited_from: id)
          user_member.save!
        end
      end
    end


    def remove_member_if_empty
      if member.roles.empty?
        member.destroy
      end
    end


    def remove_inherited_roles
      MemberRole.where(inherited_from: id).group_by(&:member).each do |member, member_roles|
        member_roles.each(&:destroy)
      end
    end

end
