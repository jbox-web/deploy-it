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

module GlobalHelpers

  def create_user_membership(application, opts = {})
    create_application_membership(application, opts.merge(type: :user))
  end


  def create_group_membership(application, opts = {})
    create_application_membership(application, opts.merge(type: :group))
  end


  def create_application_membership(application, opts = {})
    member_type = opts.delete(:type){ :user }
    member_role = opts.delete(:role){ :manager }

    user = create(:user)

    if member_type == :group
      # Create group and assign user
      group = create(:group)
      group.users << user

      return user, group, *create_member(member_role, group_options(group, application))
    else
      return user, *create_member(member_role, user_options(user, application))
    end
  end


  def user_options(user, application)
    { enrolable_type: 'User',  enrolable_id: user.id, application_id: application.id }
  end


  def group_options(group, application)
    { enrolable_type: 'Group',  enrolable_id: group.id, application_id: application.id }
  end


  def create_member(role, member_opts = {})
    # Create a new member for the application
    member = Member.new(member_opts)
    member.save!

    # Create the role
    role = create_role(role)

    # Assign a role to the new member
    member_role = create(:member_role, member: member, role: role)

    return role, member, member_role
  end


  def create_role(role)
    case role
    when :manager
      perms = [
        :view_application,
        :create_application,
        :edit_application,
        :delete_application,
        :build_application,
        :manage_application,
        :manage_members
      ]
    when :developer
      perms = [
        :view_application,
        :build_application,
        :manage_application
      ]
    when :tester
      perms = [
        :view_application,
        :view_container
      ]
    end

    new_role = Role.find_by_name(role.to_s)
    if new_role.nil?
      create(:role, name: role.to_s, permissions: perms)
    else
      new_role
    end
  end

end
