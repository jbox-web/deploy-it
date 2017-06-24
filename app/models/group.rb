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

class Group < ApplicationRecord

  ## Relations
  has_and_belongs_to_many :users,
                          after_add: :user_added,
                          after_remove: :user_removed

  has_many :memberships, as: :enrolable, class_name: 'Member', dependent: :destroy
  has_many :applications, through: :memberships

  ## Basic Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  ## Scopes
  scope :by_name, -> { order(name: :asc) }


  def to_s
    name
  end


  def members
    users
  end


  private


    def user_added(user)
      memberships.each do |member|
        next if member.application.nil?

        user_member =
          Member.find_by_application_id_and_enrolable_type_and_enrolable_id(member.application_id, 'User', user.id) ||
          Member.new(application_id: member.application_id, enrolable_type: 'User', enrolable_id: user.id)

        member.member_roles.each do |member_role|
          user_member.member_roles << MemberRole.new(role: member_role.role, inherited_from: member_role.id)
        end

        user_member.save!
      end
    end


    def user_removed(user)
      memberships.each do |member|
        MemberRole.
          joins(:member).
          where("#{Member.table_name}.enrolable_type = 'User' AND #{Member.table_name}.enrolable_id = ? AND #{MemberRole.table_name}.inherited_from IN (?)", user.id, member.member_role_ids).
          each(&:destroy)
      end
    end

end
