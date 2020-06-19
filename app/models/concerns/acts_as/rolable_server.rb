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

module ActsAs
  module RolableServer
    extend ActiveSupport::Concern

    included do
      has_many :roles, class_name: 'ServerRole'
      accepts_nested_attributes_for :roles
    end


    def has_role?(role)
      roles.map(&:to_s).include?(role.to_s)
    end


    def default_server_for_role?(role)
      # Roles are unique for each server so pick the first one in the list
      roles.select{ |r| r.to_s == role.to_s }.first.default_server?
    end


    def get_service_status(role)
      check_connection!(get_role_module(role))
    end


    def service_online?(role)
      result = get_service_status(role)
      result.success?
    end


    def get_role_module(role)
      roles.find_by_name(role.to_s)
    end

  end
end
