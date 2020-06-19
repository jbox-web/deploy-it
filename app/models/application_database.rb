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

class ApplicationDatabase < ApplicationRecord

  ## Relations
  belongs_to :application
  belongs_to :server

  ## Basic Validations
  validates :application_id, presence: true, uniqueness: true
  validates :server_id,      presence: true, on: :update
  validates :db_type,        presence: true
  validates :db_name,        presence: true
  validates :db_user,        presence: true
  validates :db_pass,        presence: true

  class << self

    def available_database_types
      DeployIt::AVAILABLE_DATABASES
    end

  end


  def db_host
    return '' if server.nil?
    server.send("#{db_type}_host")
  end


  def db_port
    return '' if server.nil?
    server.send("#{db_type}_port")
  end

end
