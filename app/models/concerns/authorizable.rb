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

module Authorizable
  extend ActiveSupport::Concern

  # Return true if the user is a member of application
  def member_of?(application)
    applications.to_a.include?(application)
  end


  def allowed_to?(action, context, options = {}, &block)
    if context && context.is_a?(Application)
      return false unless context.allows_to?(action)
      # Admin users are authorized for anything else
      return true if admin?

      roles = roles_for_application(context)
      return false unless roles
      roles.any? {|role|
        role.allowed_to?(action) &&
        (block_given? ? yield(role, self) : true)
      }
    elsif context && context.is_a?(Array)
      if context.empty?
        false
      else
        # Authorize if user is authorized on every element of the array
        context.map { |application| allowed_to?(action, application, options, &block) }.reduce(:&)
      end
    elsif options[:global]
      # Admin users are always authorized
      return true if admin?

      # authorize if user has at least one role that has this permission
      roles = memberships.includes(:roles).collect { |m| m.roles }.flatten.uniq
      roles << (self.logged? ? Role.non_member : Role.anonymous)
      roles.any? do |role|
        role.allowed_to?(action) &&
        (block_given? ? yield(role, self) : true)
      end
    else
      false
    end
  end


  # Return user's roles for application
  def roles_for_application(application)
    roles = []
    return roles if application.nil?
    if membership = membership(application)
      roles = membership.roles
    end
    roles
  end


  # Returns a hash of user's applications grouped by roles
  def applications_by_role
    return @applications_by_role if @applications_by_role

    @applications_by_role = Hash.new([])
    memberships.includes([:application, :roles]).each do |membership|
      if membership.application
        membership.roles.each do |role|
          @applications_by_role[role] = [] unless @applications_by_role.key?(role)
          @applications_by_role[role] << membership.application
        end
      end
    end
    @applications_by_role.each do |role, applications|
      applications.uniq!
    end

    @applications_by_role
  end


  # Returns user's membership for the given application
  # or nil if the user is not a member of application
  def membership(application)
    application_id = application.is_a?(Application) ? application.id : application

    @membership_by_application_id ||= Hash.new {|h, application_id|
      # h[application_id] = memberships.first
      h[application_id] = memberships.where(application_id: application_id).first
    }
    # puts YAML::dump(@membership_by_application_id)
    @membership_by_application_id[application_id]
  end

end
