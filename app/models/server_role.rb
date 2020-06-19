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

class ServerRole < ApplicationRecord

  SERVER_ROLES_AVAILABLE = %w[ pg_db mysql_db docker lb log ]

  ## Relations
  belongs_to :platform
  belongs_to :server

  ## Basic Validations
  validates :platform_id, presence: true
  validates :server_id,   presence: true
  validates :name,        presence: true, uniqueness: { scope: :server_id }, inclusion: { in: SERVER_ROLES_AVAILABLE }

  # TODO: validate docker_port and connection_timeout
  # validates :docker_port,        numericality: { only_integer: true }, on: :update
  # validates :connection_timeout, numericality: { only_integer: true }, on: :update

  ## Additionnal Validations
  validate :valid_default_uniqueness

  ## Scopes
  scope :by_role,        -> { order(name: :asc) }
  scope :default_server, -> { where(default_server: true) }

  SERVER_ROLES_AVAILABLE.each do |role|
    scope "role_#{role}".to_sym, -> { where(name: role) }
  end


  class << self

    def jbox_role_modules
      @@jbox_role_modules ||= SERVER_ROLES_AVAILABLE.sort.collect{ |r| JboxRoleModule.new(r) }
    end


    def find_jbox_role_module(name)
      if SERVER_ROLES_AVAILABLE.include?(name)
        JboxRoleModule.new(name)
      else
        raise ActiveRecord::RecordNotFound
      end
    end

  end


  def to_s
    name
  end


  def to_icon
    @icon ||= JboxRoleModule.new(name).to_icon
  end


  def humanize
    @label ||= JboxRoleModule.new(name).humanize
  end


  def host
    alternative_host.present? ? alternative_host : server.ip_address
  end


  private


    # For a given platform and a given role, there is only one default server
    def valid_default_uniqueness
      existing_server = ServerRole.find_by_platform_id_and_name_and_default_server(platform_id, name, true)
      return if existing_server == self
      if default_server == true && !existing_server.nil?
        errors.add(:default_server, :taken)
        return false
      end
    end

end
