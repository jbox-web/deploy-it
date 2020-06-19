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

module DockerApplication
  module HaveAuthorizations
    extend ActiveSupport::Concern

    included do

      class << self

        # Returns a SQL conditions string used to find all applications visible by the specified user.
        #
        # Examples:
        #   Application.visible_condition(admin)        => "applications.status = 1"
        #   Application.visible_condition(normal_user)  => "((applications.status = 1) AND (applications.is_public = 1 OR applications.id IN (1,3,4)))"
        #   Application.visible_condition(anonymous)    => "((applications.status = 1) AND (applications.is_public = 1))"
        def visible_condition(user, opts = {})
          allowed_to_condition(user, :view_application, opts)
        end


        # Returns a SQL conditions string used to find all applications for which +user+ has the given +permission+
        #
        # Valid options:
        # * :application => limit the condition to application
        # * :member      => limit the condition to the user's applications
        def allowed_to_condition(user, permission, options = {})
          perm = DeployIt::AccessControl.permission(permission)

          base_statement = ""

          if options[:application]
            application_statement = "#{Application.table_name}.id = #{options[:application].id}"
            base_statement = "(#{application_statement})"
          end

          if user && user.admin?
            ""
          else
            statement_by_role = {}
            if user && user.logged?
              user.applications_by_role.each do |role, applications|
                if role.allowed_to?(permission) && applications.any?
                  statement_by_role[role] = "#{Application.table_name}.id IN (#{applications.collect(&:id).join(',')})"
                end
              end
            end

            if statement_by_role.empty?
              "1=0"
            else
              if block_given?
                statement_by_role.each do |role, statement|
                  if s = yield(role, user)
                    statement_by_role[role] = "(#{statement} AND (#{s}))"
                  end
                end
              end
              request = statement_by_role.values.join(' OR ')
              if base_statement.empty?
                request
              else
                "( (#{base_statement}) AND (#{request}) )"
              end
            end
          end
        end

      end

    end


    # Returns true if the application is visible to +user+ or to the current user.
    #
    def visible?(user)
      user.allowed_to?(:view_application, self)
    end


    # Return true if role is allowed to do the specified action
    # action can be:
    # * a parameter-like Hash (eg. :controller => 'applications', :action => 'edit')
    # * a permission Symbol (eg. :edit_application)
    #
    def allows_to?(action)
      if action.is_a? Hash
        allowed_actions.include? "#{action[:controller]}/#{action[:action]}"
      else
        allowed_permissions.include? action
      end
    end


    def calculated_members
      app_members = []
      app_members += self.users
      self.groups.includes(:users).each do |group|
        app_members += group.users
      end
      app_members.uniq
    end


    # Returns a hash of application's users grouped by role
    def users_by_role
      members.includes(:enrolable, :roles).inject({}) do |h, m|
        m.roles.each do |r|
          h[r] ||= []
          h[r] << m.name if m.type == 'User'
        end
        h
      end
    end


    private


      def allowed_actions
        @actions_allowed ||= allowed_permissions.inject([]) { |actions, permission| actions += DeployIt::AccessControl.allowed_actions(permission) }.flatten
      end


      def allowed_permissions
        @allowed_permissions ||= begin
          module_names = [ 'containers' ]
          DeployIt::AccessControl.modules_permissions(module_names).collect { |p| p.name }
        end
      end

  end
end
