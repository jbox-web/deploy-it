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

class Member < ActiveRecord::Base

  ## Relations
  belongs_to :enrolable, polymorphic: true
  belongs_to :application

  has_many :member_roles, dependent: :destroy
  has_many :roles, through: :member_roles

  ## Validations
  validates :application_id, presence: true
  # validate :validate_role


  class << self
    # Finds or initilizes a Member for the given application and user
    def find_or_new(application, user)
      application_id = application.is_a?(Application) ? application.id : application
      user_id        = user.is_a?(User) ? user.id : user

      member =
        Member.find_by_application_id_and_enrolable_type_and_enrolable_id(application_id, 'User', user_id) ||
        Member.new(application_id: application_id, enrolable_type: 'User', enrolable_id: user_id)

      member
    end
  end


  def name
    if type == 'User'
      self.enrolable.login
    else
      self.enrolable.name
    end
  end


  def type
    self.enrolable_type
  end


  def deletable?
    member_roles.detect {|mr| mr.inherited_from}.nil?
  end


  def include?(user)
    enrolable == user
  end


  def role_ids=(arg)
    ids = (arg || []).collect(&:to_i) - [0]
    # Keep inherited roles
    ids += member_roles.select {|mr| !mr.inherited_from.nil?}.collect(&:role_id)

    new_role_ids = ids - role_ids
    # Add new roles
    new_role_ids.each {|id| member_roles << MemberRole.new(role_id: id) }
    # Remove roles (Rails' #role_ids= will not trigger MemberRole#on_destroy)
    member_roles_to_destroy = member_roles.select {|mr| !ids.include?(mr.role_id)}
    if member_roles_to_destroy.any?
      member_roles_to_destroy.each(&:destroy)
    end
  end


  def destroy
    if member_roles.reload.present?
      # destroying the last role will destroy another instance
      # of the same Member record, #super would then trigger callbacks twice
      member_roles.destroy_all
      @destroyed = true
      freeze
    else
      super
    end
  end


  private


    def validate_role
      errors.add_on_empty :roles if member_roles.empty? && roles.empty?
    end

end
