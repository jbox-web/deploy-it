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

class Role < ApplicationRecord

  # Built-in roles
  BUILTIN_NON_MEMBER = 1
  BUILTIN_ANONYMOUS  = 2

  ## Relations
  has_many :member_roles, dependent: :destroy
  has_many :members, through: :member_roles

  ## Basic Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  ## Serializer
  serialize :permissions, Array

  ## Callbacks
  before_destroy :check_deletable

  ## Scopes
  scope :sorted,  -> { order("#{table_name}.builtin ASC, #{table_name}.position ASC") }
  scope :givable, -> { order("#{table_name}.position ASC").where(builtin: 0) }

  ## ActsAsList gem
  acts_as_list


  class << self

    # Return the builtin 'non member' role.
    # If the role doesn't exist it will be created on the fly.
    def non_member
      find_or_create_system_role(BUILTIN_NON_MEMBER, 'Non member')
    end


    # Return the builtin 'anonymous' role.
    # If the role doesn't exist it will be created on the fly.
    def anonymous
      find_or_create_system_role(BUILTIN_ANONYMOUS, 'Anonymous')
    end


    def find_or_create_system_role(builtin, name)
      role = where(builtin: builtin).first
      if role.nil?
        role = create(name: name, position: 0) do |r|
          r.builtin = builtin
        end
        raise "Unable to create the #{name} role." if role.new_record?
      end
      role
    end

  end


  def to_s
    name
  end


  def name
    case builtin
    when 1
      I18n.t('label.role.non_member', default: read_attribute(:name))
    when 2
      I18n.t('label.role.anonymous', default: read_attribute(:name))
    else
      read_attribute(:name)
    end
  end


  def permissions=(perms)
    perms = perms.collect {|p| p.to_sym unless p.blank? }.compact.uniq if perms
    write_attribute(:permissions, perms)
  end


  # Return all the permissions that can be given to the role
  def setable_permissions
    setable_permissions = DeployIt::AccessControl.permissions - DeployIt::AccessControl.public_permissions
    setable_permissions -= DeployIt::AccessControl.members_only_permissions if self.builtin == BUILTIN_NON_MEMBER
    setable_permissions -= DeployIt::AccessControl.loggedin_only_permissions if self.builtin == BUILTIN_ANONYMOUS
    setable_permissions
  end


  # Return true if role is allowed to do the specified action
  # action can be:
  # * a parameter-like Hash (eg. :controller => 'applications', :action => 'edit')
  # * a permission Symbol (eg. :edit_application)
  def allowed_to?(action)
    if action.is_a? Hash
      allowed_actions.include? "#{action[:controller]}/#{action[:action]}"
    else
      allowed_permissions.include? action
    end
  end


  # def <=>(role)
  #   if role
  #     if builtin == role.builtin
  #       position <=> role.position
  #     else
  #       builtin <=> role.builtin
  #     end
  #   else
  #     -1
  #   end
  # end


  # Return true if the role is a builtin role
  def builtin?
    builtin != 0
  end


  # Return true if the role is the anonymous role
  def anonymous?
    builtin == 2
  end


  # Return true if the role is an application member role
  def member?
    !builtin?
  end


  private


    def allowed_actions
      @actions_allowed ||= allowed_permissions.inject([]) { |actions, permission| actions += DeployIt::AccessControl.allowed_actions(permission) }.flatten
    end


    def allowed_permissions
      @allowed_permissions ||= permissions + DeployIt::AccessControl.public_permissions.collect {|p| p.name}
    end


    def check_deletable
      raise "Can't delete role" if members.any?
      raise "Can't delete builtin role" if builtin?
    end

end
